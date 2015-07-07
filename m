From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v8 03/11] KVM: arm: guest debug, add stub KVM_SET_GUEST_DEBUG ioctl
Date: Tue,  7 Jul 2015 17:29:55 +0100
Message-ID: <1436286603-15192-4-git-send-email-alex.bennee@linaro.org>
References: <1436286603-15192-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436286603-15192-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

This commit adds a stub function to support the KVM_SET_GUEST_DEBUG
ioctl. Any unsupported flag will return -EINVAL. For now, only
KVM_GUESTDBG_ENABLE is supported, although it won't have any effects.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>.
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

---
v2
  - simplified form of the ioctl (stuff will go into setup_debug)
v3
 - KVM_GUESTDBG_VALID->KVM_GUESTDBG_VALID_MASK
 - move mask check to the top of function
 - add ioctl doc header
 - split capability into separate patch
 - tweaked commit wording w.r.t return of -EINVAL
v4
 - add r-b-tag
v7
 - moved ioctl to arm64/kvm/guest.c, stubbed arm/kvm/guest.c
---
 Documentation/virtual/kvm/api.txt |  2 +-
 arch/arm/kvm/arm.c                |  7 -------
 arch/arm/kvm/guest.c              |  6 ++++++
 arch/arm64/kvm/guest.c            | 27 +++++++++++++++++++++++++++
 4 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
index c34c32d..ba635c7 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2645,7 +2645,7 @@ handled.
 4.87 KVM_SET_GUEST_DEBUG
=20
 Capability: KVM_CAP_SET_GUEST_DEBUG
-Architectures: x86, s390, ppc
+Architectures: x86, s390, ppc, arm64
 Type: vcpu ioctl
 Parameters: struct kvm_guest_debug (in)
 Returns: 0 on success; -1 on error
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d9631ec..92b80bc 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -302,13 +302,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_arm_set_running_vcpu(NULL);
 }
=20
-int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
-					struct kvm_guest_debug *dbg)
-{
-	return -EINVAL;
-}
-
-
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index d503fbb..96e935b 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -290,3 +290,9 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *=
vcpu,
 {
 	return -EINVAL;
 }
+
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
+{
+	return -EINVAL;
+}
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9535bd5..0ba8677 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -331,3 +331,30 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu =
*vcpu,
 {
 	return -EINVAL;
 }
+
+#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE)
+
+/**
+ * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
+ * @kvm:	pointer to the KVM struct
+ * @kvm_guest_debug: the ioctl data buffer
+ *
+ * This sets up and enables the VM for guest debugging. Userspace
+ * passes in a control flag to enable different debug types and
+ * potentially other architecture specific information in the rest of
+ * the structure.
+ */
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
+{
+	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
+		return -EINVAL;
+
+	if (dbg->control & KVM_GUESTDBG_ENABLE) {
+		vcpu->guest_debug =3D dbg->control;
+	} else {
+		/* If not enabled clear all flags */
+		vcpu->guest_debug =3D 0;
+	}
+	return 0;
+}
--=20
2.4.5

