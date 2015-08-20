From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/25] KVM: add comments for kvm_debug_exit_arch struct
Date: Thu, 20 Aug 2015 17:28:39 +0100
Message-ID: <1440088143-4722-2-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, David Hildenbrand <dahi@linux.vnet.ibm.com>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

=46rom: Alex Benn=C3=A9e <alex.bennee@linaro.org>

Bring into line with the comments for the other structures and their
KVM_EXIT_* cases. Also update api.txt to reflect use in kvm_run
documentation.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 4 +++-
 include/uapi/linux/kvm.h          | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
index a7926a9..9f746ea 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3111,11 +3111,13 @@ data_offset describes where the data is located=
 (KVM_EXIT_IO_OUT) or
 where kvm expects application code to place the data for the next
 KVM_RUN invocation (KVM_EXIT_IO_IN).  Data format is a packed array.
=20
+		/* KVM_EXIT_DEBUG */
 		struct {
 			struct kvm_debug_exit_arch arch;
 		} debug;
=20
-Unused.
+If the exit_reason is KVM_EXIT_DEBUG, then a vcpu is processing a debu=
g event
+for which architecture specific information is returned.
=20
 		/* KVM_EXIT_MMIO */
 		struct {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 716ad4a..4ab3c6a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -237,6 +237,7 @@ struct kvm_run {
 			__u32 count;
 			__u64 data_offset; /* relative to kvm_run start */
 		} io;
+		/* KVM_EXIT_DEBUG */
 		struct {
 			struct kvm_debug_exit_arch arch;
 		} debug;
@@ -285,6 +286,7 @@ struct kvm_run {
 			__u32 data;
 			__u8  is_write;
 		} dcr;
+		/* KVM_EXIT_INTERNAL_ERROR */
 		struct {
 			__u32 suberror;
 			/* Available with KVM_CAP_INTERNAL_ERROR_DATA: */
@@ -295,6 +297,7 @@ struct kvm_run {
 		struct {
 			__u64 gprs[32];
 		} osi;
+		/* KVM_EXIT_PAPR_HCALL */
 		struct {
 			__u64 nr;
 			__u64 ret;
--=20
2.1.4

