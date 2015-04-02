From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 12/27] arm/arm64: KVM: export VCPU power state via MP_STATE ioctl
Date: Thu,  2 Apr 2015 11:05:16 +0100
Message-ID: <1427969131-8445-13-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Eric Auger <eric.auger@linaro.org>, Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

=46rom: Alex Benn=C3=A9e <alex.bennee@linaro.org>

To cleanly restore an SMP VM we need to ensure that the current pause
state of each vcpu is correctly recorded. Things could get confused if
the CPU starts running after migration restore completes when it was
paused before it state was captured.

We use the existing KVM_GET/SET_MP_STATE ioctl to do this. The arm/arm6=
4
interface is a lot simpler as the only valid states are
KVM_MP_STATE_RUNNABLE and KVM_MP_STATE_STOPPED.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/virtual/kvm/api.txt | 16 ++++++++++++----
 arch/arm/kvm/arm.c                | 21 +++++++++++++++++++--
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
index b265d8e..71d10d7 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -997,7 +997,7 @@ for vm-wide capabilities.
 4.38 KVM_GET_MP_STATE
=20
 Capability: KVM_CAP_MP_STATE
-Architectures: x86, s390
+Architectures: x86, s390, arm, arm64
 Type: vcpu ioctl
 Parameters: struct kvm_mp_state (out)
 Returns: 0 on success; -1 on error
@@ -1011,7 +1011,7 @@ uniprocessor guests).
=20
 Possible values are:
=20
- - KVM_MP_STATE_RUNNABLE:        the vcpu is currently running [x86]
+ - KVM_MP_STATE_RUNNABLE:        the vcpu is currently running [x86,ar=
m/arm64]
  - KVM_MP_STATE_UNINITIALIZED:   the vcpu is an application processor =
(AP)
                                  which has not yet received an INIT si=
gnal [x86]
  - KVM_MP_STATE_INIT_RECEIVED:   the vcpu has received an INIT signal,=
 and is
@@ -1020,7 +1020,7 @@ Possible values are:
                                  is waiting for an interrupt [x86]
  - KVM_MP_STATE_SIPI_RECEIVED:   the vcpu has just received a SIPI (ve=
ctor
                                  accessible via KVM_GET_VCPU_EVENTS) [=
x86]
- - KVM_MP_STATE_STOPPED:         the vcpu is stopped [s390]
+ - KVM_MP_STATE_STOPPED:         the vcpu is stopped [s390,arm/arm64]
  - KVM_MP_STATE_CHECK_STOP:      the vcpu is in a special error state =
[s390]
  - KVM_MP_STATE_OPERATING:       the vcpu is operating (running or hal=
ted)
                                  [s390]
@@ -1031,11 +1031,15 @@ On x86, this ioctl is only useful after KVM_CRE=
ATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by use=
rspace on
 these architectures.
=20
+For arm/arm64:
+
+The only states that are valid are KVM_MP_STATE_STOPPED and
+KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
=20
 4.39 KVM_SET_MP_STATE
=20
 Capability: KVM_CAP_MP_STATE
-Architectures: x86, s390
+Architectures: x86, s390, arm, arm64
 Type: vcpu ioctl
 Parameters: struct kvm_mp_state (in)
 Returns: 0 on success; -1 on error
@@ -1047,6 +1051,10 @@ On x86, this ioctl is only useful after KVM_CREA=
TE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by use=
rspace on
 these architectures.
=20
+For arm/arm64:
+
+The only states that are valid are KVM_MP_STATE_STOPPED and
+KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or no=
t.
=20
 4.40 KVM_SET_IDENTITY_MAP_ADDR
=20
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index cc96619..9a5f057 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -180,6 +180,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
 	case KVM_CAP_ARM_PSCI:
 	case KVM_CAP_ARM_PSCI_0_2:
 	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_MP_STATE:
 		r =3D 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -310,13 +311,29 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kv=
m_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	return -EINVAL;
+	if (vcpu->arch.pause)
+		mp_state->mp_state =3D KVM_MP_STATE_STOPPED;
+	else
+		mp_state->mp_state =3D KVM_MP_STATE_RUNNABLE;
+
+	return 0;
 }
=20
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	return -EINVAL;
+	switch (mp_state->mp_state) {
+	case KVM_MP_STATE_RUNNABLE:
+		vcpu->arch.pause =3D false;
+		break;
+	case KVM_MP_STATE_STOPPED:
+		vcpu->arch.pause =3D true;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
 }
=20
 /**
--=20
2.1.4

