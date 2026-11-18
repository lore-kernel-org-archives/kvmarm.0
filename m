Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007150;
	b=3UdKLtE2eq0LfqeYidEMWpNyMiO0O3nXU2/UI96ZfJOWB9nb1NDm5rhsOK5gE1SIPY+6
	 eBMUSEHIol5h55eDAkGZL5vHo9Bc2S30GGtg3TDtXhtGARQYSIg+jc5a9RNsww2EbNxrV
	 iHCcq3k+SS5Na+UzEr1in8gmDiQM4KdTSOZpD7g9m8yvE+AN6uaKaryEUhvvKvUD6MRj4
	 7yl+Igx4XAUjR79M8slzQ+3KQA7pzyZL3TpG44eVFoh+nGH9R7ZmWKxGu6ot6xexl+wQl
	 rmnshwUV/ASA7/7QpznhJmtoIpEYPOQQ/3rn+QAfzsZNE+fVhlwDPb95NZyBssaaLEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007150;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=GV42NBFC824GmYTgXC3pNtMM+aqAM6VsyNgZJMIPRbM=;
	b=y5B9lbbhFsH8WX640Q5UYkYe7jKGpGzkWpCVRqX0GKsHmwQlk6BYS9OM2NHNlQj1Njd+
	 9Pv4nWwERUAQdrthGN5S/dW8Hkv7jge9dxGiyvZZ/PtKQOurboZDRqgz4l+7cJPYRdVat
	 NbW+7bFvnGFxoJHICSQ+0mswp9zvKzF4fCg39JcqLS4OSJmBfOYCq4GwwJ6rZPXDeISXB
	 uPBrljuG3QUF93iAmuyLi6R1rVbr1j0hP50rtSAqUD14f8f0JZDQV0HSPh/xY482V7YB+
	 L0xwjItObh/rYVvpW+wDjcNp0EOi4ihoBNlzYcuoSnghlGBhxIMygAevhlA4eCV+diA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=EkMvo9u4;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D101606A332
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 13:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D101606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=EkMvo9u4
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so7145985e9.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 05:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795007148; x=1795611948; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GV42NBFC824GmYTgXC3pNtMM+aqAM6VsyNgZJMIPRbM=;
        b=EkMvo9u4FXi5jc/sXi+zQhljDwNZpcn/H8LecrsogGNRtlfLCyGizw5BJVVD4B0J38
         9qP9VIckORy48UnwCb/cKFAHaXE2YyjxiPTGPBUlNijHi6aLXNDRw9jC60x3tb85LXtf
         ZMNCA7tyrj43+PcSBWLp9ic+8Z4Jcngzoq78RfCXbuRXWkYnqgEy+y/UOoF0RCXoejZG
         doic424RYMctHx1Cs2vpC3Wfa7ykCsGpLB+9VQK5/haf73kzQ8Qqy11xLIqpvK6fx+ut
         u4p2TgNNd8w1IMNzjInPp1bho4PRhlSkQ9ffd69qsLLO6MJYnBEuWSBv+euweL+kERXn
         NGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795007148; x=1795611948;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GV42NBFC824GmYTgXC3pNtMM+aqAM6VsyNgZJMIPRbM=;
        b=ns/5oUibSVbB9/Le1gQUSG4Owy91wBKaV3EhWiy5PWg8T19iXLDixcCjtvwPSQkDC3
         myH9Qo1LXXgQSnpN8Mz29CACRJq4zZkd78YwRAKQOW3VouF+QqTNEQRGoxv3aNGoJDZL
         9sm4qwfzIGbzPMuLa16BG7JytsFh0C3q7KOHTQmeC14VLJNnyB+JUFo3rZiNbwLwcHuI
         hejFKl02Nv5wqLdXQWafWguwg40PhjPHYE1SKsy9ivw/1ZJLu4L9F2oiN/uwojBjzAjg
         wT+p6Edxu4VMnN4YeM9AKarhDGHtmvEzj34VhCuXVwjza7lcAXDXy5mUiP5g8xzAAMBu
         PADg==
X-Forwarded-Encrypted: i=1; AL+hErH1SVFxzvUddxqZmYswZVOo6b6vUdd/nYNI4mlR6FRmKKfd57krzPzbqYMA7HnyJX6bdXqTyEY=@lists.linux.dev
X-Gm-Message-State: APuU4Z9N5p51scNqWmBq4PZpnKlCapoWquElFmyn2gNTisUPEVkqTPPt
	LdKK6ZFEwo2hG64s23CIISOf3KHZe6RcNQ5AMXJZlZ6NiPPZ0jbysSNOL3w0qLUOEn4=
X-Gm-Gg: AYBFou1nkl7w5Uh3ORowMkde5O2vfHhtk3HHKcwUkPpbEsOlmVazAZj25aIGptWBqQx
	cf2MSZGartjo5ZzKZAm6LGl3Af7UcPVuzUPNYoBfXW78rp64tCzpprxDyG27n1wcGx5ZOPNuh9Z
	Ns/sKrkDu6ifAlyU/NVVhubkO8cIRIxTrZNpbsYEUkbMy6k5WcgZgIy7wyQrBHsiogHOBGZlmwe
	1w4Qmn/xZ3Yr8AVC/KxkJ8EXzrpXGN8+jrnRLl7X5h5LReECiJgyc9iWVGg1+u78u02SKqn7TYm
	qCUcb9u87N5i3bGk9jlxzTP9sAKlQmEZc1izMtzsTTkMQ6iNehjKxbxw1zqDf/2WXvQbKlaMgVR
	1Eiz7rAwiTpmIVUR67yL0Iy4djSVQv5dj1hOXb2GrT6EAENeQHkEAq6ATCfWfvQ7noc8GTCVnT8
	1sL+xwaJTz+uMDYJQlt+GV6ZDF2K2xCOdJBv6fvDo5CuF9cl0GP2tZZ7uR1Bek+xXf7f2y9scoH
	E13umrqQvWrO9pwt+O/3CERwSolckff5QmcPHX04DiSah2ay5AEd6qzC4IG2OGEO9SW6tYE+Vjd
	Pzx33rsaCVp155iN6mds0LQNURZo+ZCMBQ+IyrdX
X-Received: by 2002:a05:600c:524d:b0:49f:ce78:356d with SMTP id 5b1f17b1804b1-4bb7da46634mr47832835e9.30.1795007148303;
        Wed, 18 Nov 2026 05:05:48 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d4f5b87sm42724095e9.2.2026.11.18.05.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 05:05:47 -0800 (PST)
Date: Wed, 18 Nov 2026 16:05:44 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH v2 1/2] KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS
Message-ID: <033a2d49e0f48426281b46eb1131ae64012aba18.1795006659.git.dan@pereq.eu>
References: <cover.1795006659.git.dan@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1795006659.git.dan@pereq.eu>

Nested virtualization can trigger a NULL pointer dereference of
vcpu->arch.hw_mmu in kvm_inject_nested():

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000084
  kvm_vcpu_put_hw_mmu (arch/arm64/kvm/nested.c:1046) (P)
  vhe_vcpu_put (arch/arm64/kvm/arm.c:827)
  kvm_arch_vcpu_put (arch/arm64/kvm/arm.c:860)
  kvm_inject_nested (arch/arm64/kvm/emulate-nested.c:2903)
  kvm_inject_nested_serror (arch/arm64/kvm/emulate-nested.c:2976)
  kvm_inject_serror_esr (arch/arm64/kvm/inject_fault.c:365)
  __kvm_arm_vcpu_set_events (arch/arm64/kvm/guest.c:827)
  kvm_arch_vcpu_ioctl (arch/arm64/kvm/arm.c:2017 arch/arm64/kvm/arm.c:2157)
  kvm_vcpu_ioctl (arch/arm64/kvm/../../../virt/kvm/kvm_main.c:4772)

The KVM_SET_VCPU_EVENTS ioctl does not load the vcpu, it just injects a
pending SError or external abort straight away.  If the vcpu is in L2
context and L1 has asked for the exception, kvm_inject_nested() puts and
loads a vcpu that is not loaded which leads to a NULL pointer dereference.

Load the vcpu in kvm_arm_vcpu_set_events() so that kvm_inject_nested()
always finds a loaded vcpu.

Fixes: 9aba641b9ec2 ("KVM: arm64: nv: Respect exception routing rules for SEAs")
Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
In v1, I added checks for if the vcpu was loaded.  This version calls
vcpu_load() in the caller instead.  That's more like what x86 does.

Also Sashiko found an additional bug in v1 and I have added a fix for
that as patch 2/2.

 arch/arm64/kvm/arm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 84a52e27ed85..a148e80d0aef 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2002,7 +2002,7 @@ static int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 				   struct kvm_vcpu_events *events)
 {
-	int i;
+	int i, ret;
 
 	/* check whether the reserved field is zero */
 	for (i = 0; i < ARRAY_SIZE(events->reserved); i++)
@@ -2014,7 +2014,11 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 		if (events->exception.pad[i])
 			return -EINVAL;
 
-	return __kvm_arm_vcpu_set_events(vcpu, events);
+	vcpu_load(vcpu);
+	ret = __kvm_arm_vcpu_set_events(vcpu, events);
+	vcpu_put(vcpu);
+
+	return ret;
 }
 
 /*
-- 
2.53.0

