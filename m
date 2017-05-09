From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 01/11] KVM: arm/arm64: Clarification and relaxation to ITS save/restore ABI
Date: Tue,  9 May 2017 10:56:08 +0200
Message-ID: <20170509085618.28311-2-cdall@linaro.org>
References: <20170509085618.28311-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509085618.28311-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Clarify what is meant by the save/restore ABI only supporting virtual
physical interrupts.

Relax the requirement of the order that the collection entries are
written in and be clear that there is no particular ordering enforced.

Some cosmetic changes in the capitalization of ID names to align with
the GICv3 manual and remove the empty line in the bottom of the patch.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-its.txt | 23 +++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
index ba132e9..eb06beb 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
@@ -97,8 +97,8 @@ Groups:
 The following ordering must be followed when restoring the GIC and the ITS:
 a) restore all guest memory and create vcpus
 b) restore all redistributors
-c) initialize the ITS and then provide its base address
-   (KVM_DEV_ARM_VGIC_CTRL_INIT, KVM_DEV_ARM_VGIC_GRP_ADDR)
+c) provide the its base address
+   (KVM_DEV_ARM_VGIC_GRP_ADDR)
 d) restore the ITS in the following order:
    1. Restore GITS_CBASER
    2. Restore all other GITS_ registers, except GITS_CTLR!
@@ -110,12 +110,14 @@ Then vcpus can be started.
  ITS Table ABI REV0:
  -------------------
 
- Revision 0 of the ABI only supports physical LPIs.
+ Revision 0 of the ABI only supports the features of a virtual GICv3, and does
+ not support a virtual GICv4 with support for direct injection of virtual
+ interrupts for nested hypervisors.
 
- The device table and ITT are indexed by the deviceid and eventid,
- respectively. The collection table is not indexed by collectionid:
- CTEs are written in the table in the order of collection creation. All
- entries are 8 bytes.
+ The device table and ITT are indexed by the DeviceID and EventID,
+ respectively. The collection table is not indexed by CollectionID, and the
+ entries in the collection are listed in no particular order.
+ All entries are 8 bytes.
 
  Device Table Entry (DTE):
 
@@ -126,10 +128,10 @@ Then vcpus can be started.
  - V indicates whether the entry is valid. If not, other fields
    are not meaningful.
  - next: equals to 0 if this entry is the last one; otherwise it
-   corresponds to the deviceid offset to the next DTE, capped by
+   corresponds to the DeviceID offset to the next DTE, capped by
    2^14 -1.
  - ITT_addr matches bits [51:8] of the ITT address (256 Byte aligned).
- - Size specifies the supported number of bits for the eventid,
+ - Size specifies the supported number of bits for the EventID,
    minus one
 
  Collection Table Entry (CTE):
@@ -151,8 +153,7 @@ Then vcpus can be started.
 
  where:
  - next: equals to 0 if this entry is the last one; otherwise it corresponds
-   to the eventid offset to the next ITE capped by 2^16 -1.
+   to the EventID offset to the next ITE capped by 2^16 -1.
  - pINTID is the physical LPI ID; if zero, it means the entry is not valid
    and other fields are not meaningful.
  - ICID is the collection ID
-
-- 
2.9.0
