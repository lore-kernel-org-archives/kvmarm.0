From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: [PATCH AUTOSEL 4.14 41/67] KVM: arm/arm64: vgic: Fix possible
 spectre-v1 write in vgic_mmio_write_apr()
Date: Fri, 7 Sep 2018 00:37:52 +0000
Message-ID: <20180907003716.57737-41-alexander.levin@microsoft.com>
References: <20180907003716.57737-1-alexander.levin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180907003716.57737-1-alexander.levin@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Sasha Levin <Alexander.Levin@microsoft.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 6b8b9a48545e08345b8ff77c9fd51b1aebdbefb3 ]

It's possible for userspace to control n. Sanitize n when using it as an
array index, to inhibit the potential spectre-v1 write gadget.

Note that while it appears that n must be bound to the interval [0,3]
due to the way it is extracted from addr, we cannot guarantee that
compiler transformations (and/or future refactoring) will ensure this is
the case, and given this is a slow path it's better to always perform
the masking.

Found by smatch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio=
-v2.c
index af003268bf3e..7ea5928244fa 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -348,6 +348,9 @@ static void vgic_mmio_write_apr(struct kvm_vcpu *vcpu,
=20
 		if (n > vgic_v3_max_apr_idx(vcpu))
 			return;
+
+		n =3D array_index_nospec(n, 4);
+
 		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
 		vgicv3->vgic_ap1r[n] =3D val;
 	}
--=20
2.17.1
