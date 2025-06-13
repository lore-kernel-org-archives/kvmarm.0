Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD0D19E7E2
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829978; cv=none; b=kZ6dvX2FLbjVn0g/gLK/7Vhs04sOj3RrlqKGcTavZ586cTYJ9JdXdoJdHVQV0KuybTGBWn8jQJVWyG0tHzF4h6ZTVGmGv3VRsgSHRSCDqcXTtgnlm1+WE6aCVo5yRIvScaMzxnHElnj5Kbtn6dQe5i4kzW7WzdS/96qpPKv7rW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829978; c=relaxed/simple;
	bh=vxkacs+qUolHE8ofOSXElM6uFZzrXDwx3yDd3lw+TdE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oTe8Wm9LKWzDToF0m4+vMuVeKH+a+qouPqTwM3YfBizduRqcF1Q5uV1sYy7mtGkMig/vK9zNkZb90pnxwysiGThFacUaI/IaUvnZSyJfDbb4Itiw0y2yNEQvn7sq+mxJQeyXNrR28dwWF76WXcXs+c/U5PGDc9il+YIj0Hi0Rc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H055ZImE; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H055ZImE"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddc147611fso44166525ab.3
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 08:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829976; x=1750434776; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OFF6SOp13MfI+rKYc7dCezNEaDk/WUOkhnG6IJMmr80=;
        b=H055ZImEG8D2H5LNFEYQV/KBS1q9vBImwuBnHUHa8pBLITILvbWaqxqsQvDe85cbaZ
         d+wPhsrmXNc+3cggdMOKVxsnYeU/sevfyiYhqTCwjb6677cCjz2rJjHWkLkBJG67KcL9
         WE+9S9zd1Q8HHvzm2j8ILPI4PTyPN/VRqmw5ulhbbVCy60o5PGoM9VTNYn7O6V6gcRtr
         ksxybPTtdpLFMzMpypRrRrHftrxC8ELumWiKR2+R7I7OpAOg+9sW29ncBenyFcjmG/nW
         ZjpLV1on+1OdLuzhsGVbPqqYAla3om1PU/TLMpye27IlVbR+tR4PMv5I9yZThpQgN/h4
         /Efw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829976; x=1750434776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OFF6SOp13MfI+rKYc7dCezNEaDk/WUOkhnG6IJMmr80=;
        b=SRsHF3raljZeas9b4zzhKnOti1edmLB+ZEuEFPaBi0/T86Im0UF1m94mMwZ3lMuBEf
         HG/y4scTiBvdWmZRxX9V0oj0pmHIcZrqW29973nC3T/4qs7yOQXEfBJDH90HcpCg9ZMD
         4UU0yqMwVTaC1JauhLY/FyO33U/WADi/XbNWF+XJVeOJUDRfI8+1sFG0akXW0O1Oxqpp
         XHze8S8kOtbS8F9BE3ZuoSj7RpaR0ID1Mz5aFppF1APSJgFL35iEX+rkOdXmbsRL8rsa
         IM898EnDa3x3xNpQ/uaRB/W4J5DTdW/vdawt5PR9ypNR7CrW1zCsz4wVaMzO/mOI/UHz
         ZtpA==
X-Forwarded-Encrypted: i=1; AJvYcCVxswGh/duBJARfSjNAdhFt9YmXoiZeU3iCCcZTlsmQFsujCsRMtiYMOF1SWBRCLBzVqIRZIY8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhJ3S3phB50FUwLpym7XAaSNRq3V8zEqTpqmbhhRQ9Qb9OcBB5
	2tpr798U87LS7M/u3dYVCxP0F7gZN/Gb4bmgYq1PWFWaBVVvMlji01xbzSRZ3wnlNtL+qMuOVmH
	Q43UyWSjLKg==
X-Google-Smtp-Source: AGHT+IG8T3q/TFMjMeVIYD6samTw89/uinTNnuWwzxHnuwndVMxgoAdLhGBoyVqCfis1o5KW9rTeoIB0iQbo
X-Received: from oabkz22.prod.google.com ([2002:a05:6871:4096:b0:2bc:69a2:7ea5])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:a3c6:b0:2d6:667c:511f
 with SMTP id 586e51a60fabf-2eaf05ca75amr171809fac.9.1749829964975; Fri, 13
 Jun 2025 08:52:44 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:36 +0000
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-3-rananta@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

Consolidate the duplicated handling of the VGICv3 maintenance IRQ
attribute as a regular GICv3 attribute, as it is neither a register nor
a common attribute.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 51 +++++++++++++--------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f9ae790163fb..e28cf68a49c3 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -303,12 +303,6 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 			     VGIC_NR_PRIVATE_IRQS, uaddr);
 		break;
 	}
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-
-		r = put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
-		break;
-	}
 	}
 
 	return r;
@@ -523,7 +517,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
-	bool uaccess, post_init = true;
+	bool uaccess;
 	u32 val;
 	int ret;
 
@@ -539,9 +533,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		/* Sysregs uaccess is performed by the sysreg handling code */
 		uaccess = false;
 		break;
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
-		post_init = false;
-		fallthrough;
 	default:
 		uaccess = true;
 	}
@@ -561,7 +552,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
-	if (post_init != vgic_initialized(dev->kvm)) {
+	if (!vgic_initialized(dev->kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -591,19 +582,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		}
 		break;
 	}
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
-		if (!is_write) {
-			val = dev->kvm->arch.vgic.mi_intid;
-			ret = 0;
-			break;
-		}
-
-		ret = -EINVAL;
-		if ((val < VGIC_NR_PRIVATE_IRQS) && (val >= VGIC_NR_SGIS)) {
-			dev->kvm->arch.vgic.mi_intid = val;
-			ret = 0;
-		}
-		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -630,8 +608,24 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, true);
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
+		u32 __user *uaddr = (u32 __user *)attr->addr;
+		u32 val;
+
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		if (vgic_initialized(dev->kvm))
+			return -EBUSY;
+
+		if ((val < VGIC_NR_SGIS) || (val >= VGIC_NR_PRIVATE_IRQS))
+			return -EINVAL;
+
+		dev->kvm->arch.vgic.mi_intid = val;
+		return 0;
+	}
 	default:
 		return vgic_set_common_attr(dev, attr);
 	}
@@ -645,8 +639,13 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, false);
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		return put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
+	}
 	default:
 		return vgic_get_common_attr(dev, attr);
 	}
-- 
2.50.0.rc2.692.g299adb8693-goog

