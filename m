From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 6/8] arm: prepare for instantiating different IRQ chip devices
Date: Tue,  9 Jun 2015 12:31:33 +0100
Message-ID: <1433849493-27463-1-git-send-email-andre.przywara@arm.com>
References: <1433493473-4002-7-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433493473-4002-7-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi, contrary to my boasting in the cover letter I managed to
accidentially drop the fix for the GIC device initialization error
handling Will requested from this series.
If we fail the GIC initialization sequence at some point, we should
make sure to not let the gic_fd initialized, so that subsequent
accesses to the GIC device fail appropriately.
So the fix below should be merged in, actually a part of it already
in patch 2/8.
If there are no further comments, I will re-spin this series with
those fixes contained in the proper patches later this week.

Cheers,
Andre.

---
diff --git a/arm/gic.c b/arm/gic.c
index ab0f594..5fb94c1 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -89,15 +89,21 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
 	default:
-		return -ENODEV;
+		err = -ENODEV;
+		break;
 	}
 	if (err)
-		return err;
+		goto out_err;
 
 	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
 	if (err)
-		return err;
+		goto out_err;
+
+	return err;
 
+out_err:
+	close(gic_fd);
+	gic_fd = -1;
 	return err;
 }
 
-- 
2.3.5

