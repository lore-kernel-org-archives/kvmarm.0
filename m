Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343383;
	b=ju/rdu2FfwRe3EyOew4MpRLn2+sXmX7xfdxj44HcHFJlfg5tvRNmCjEbZ8L+mjMC02ML
	 PCilj7O+fs9IXZrefT03+M2PApsL/JWYPJNraD4JUoHabTMNVeOvIvgVQTGIGCWb8pgsQ
	 zLu+pStxYiAyU83GdCs27dZAcMALHT9etgorWzu6sZM0Ct4kfHeQleAmBMcMxK85Q+8ER
	 RzDu0kYumoXMJKPUSI+SwL2qH0cnl8p7tmq2OO3LvocSDDY/8gIwVElCjW0Oi3NYIFx7/
	 Ll37LwyTKoOj6MrilY8xw8luowOnHyMmRZAZz5Y7yFDlAbmG9DyZPkQKfm/0AXIMUsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343383;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=6NInI68FLUylWrhgCpXBz1AP5EYWXga5qw6E6p4zJEg=;
	b=bxIKS2u2SgW8xUZv3yyGKxStjBeFUtJVSpZByGgmdfC0DAuTOw5u8OdNgz4IHQBRE8tD
	 Quf44o8jMvGm5lvxEJqOLfBI/RV4VZ6wSvFzbLLNNUa71D1etXwclTHYOo7PhxLWGAcDu
	 CFXu17zmMOlaCufvyx50HrluG5OVl0nm4iBYpKJ2HATTV0btmVnCFo++bz/kWqi8UpuNy
	 gEbSgaky0oYfBLpUXaZLBT5NQhP17ao3N7iMFpNJPyPxQyGjSDbue9CRDCTbm0ONQJLzn
	 mnrC0LOwjDYEtGrseZVQ5adCKA5n6i46sDKezV4NpkC0EjPfKmDcNHwknfDKdZAuViQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=1Dt3RBBR;
	arc=none smtp.remote-ip=113.46.200.227
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14621606A321
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 06:56:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14621606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=1Dt3RBBR
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6NInI68FLUylWrhgCpXBz1AP5EYWXga5qw6E6p4zJEg=;
	b=1Dt3RBBRT2n7vdMoPAjgRYh7Th5GGv/nngw3q8ATWLLm373zlntIDqZ5Z2eWzfgrVd/IKVkWU
	sDZlkG2TrR6Ickus9haCPKmRWK7qUwc9qnekEi2/D/wersMPzo+RMHDxlKnbyCklW+z5Buw3pjd
	NbuNxs6DAhcZxlBaqAmBK0g=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jGBhf0cydznTVn;
	Fri, 30 Oct 2026 14:56:18 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id D794640586;
	Fri, 30 Oct 2026 14:56:19 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemk300013.china.huawei.com
 (7.202.194.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 30 Oct
 2026 14:56:19 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-doc@vger.kernel.org>
CC: <maz@kernel.org>, <oupton@kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <zhengtian10@huawei.com>, <linuxarm@huawei.com>,
	<kristina.martsenko@arm.com>, <pbonzini@redhat.com>, <fuad.tabba@linux.dev>,
	<joey.gouly@arm.com>, <seiden@linux.ibm.com>, <prime.zeng@hisilicon.com>
Subject: [RFC 3/6] KVM: arm64: Wire up TLBID vDomain configuration ioctls
Date: Fri, 30 Oct 2026 14:56:14 +0800
Message-ID: <20261030065617.4090073-4-yangjinqian1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20261030065617.4090073-1-yangjinqian1@huawei.com>
References: <20261030065617.4090073-1-yangjinqian1@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300013.china.huawei.com (7.202.194.231)

Report KVM_CAP_ARM_TLBIDOMAIN from kvm_vm_ioctl_check_extension(),
and bridge KVM_ARM_VCPU_SET_VDOMAIN and KVM_ARM_GET_VDOMAIN_NUM to
their kvm_arm_* helpers, letting userspace configure each vCPU's
vDomain bitmap and get the number of vDomains.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 arch/arm64/kvm/arm.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 809d33b8e5be..4dfea015eaaa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -598,6 +598,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = kvm_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_TLBIDOMAIN:
+		if (IS_ENABLED(CONFIG_KVM_ARM_VTLBID) && has_vhe() &&
+		    system_supports_tlbid())
+			r = 1;
+		else
+			r = 0;
+		break;
 	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
 		if (kvm)
 			r = kvm->arch.mmu.split_page_chunk_size;
@@ -2437,6 +2444,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_ARM_VCPU_SET_VDOMAIN: {
+		struct kvm_arm_set_vdomain vdomain;
+
+		if (!kvm_vcpu_initialized(vcpu))
+			return -ENOEXEC;
+
+		if (copy_from_user(&vdomain, argp, sizeof(vdomain)))
+			return -EFAULT;
+
+		return kvm_arm_vcpu_set_vdomain(vcpu, &vdomain);
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -2578,6 +2596,19 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			return -EFAULT;
 		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
 	}
+	case KVM_ARM_GET_VDOMAIN_NUM: {
+		struct kvm_arm_get_vdomain vdomain;
+		int ret;
+
+		ret = kvm_arm_get_vdomain_num(kvm, &vdomain);
+		if (ret)
+			return ret;
+
+		if (copy_to_user(argp, &vdomain, sizeof(vdomain)))
+			return -EFAULT;
+
+		return 0;
+	}
 	default:
 		return -EINVAL;
 	}
-- 
2.33.0

