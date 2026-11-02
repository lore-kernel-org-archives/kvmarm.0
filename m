Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793612589;
	b=iX3KFxJJkQMHf9Dyo++7Nz3BpAN90+mFcPWnN4mLskbA6rkwdrNvGD37Fj+3BQDEFa6o
	 OOac9GJfeDckNJYW3HZdggLnFkd6bTJboeIHgOQ3jt7pbkxJytcpIzU4wNEd5mOVSi3Qh
	 c17j2MTzmu4pcNRSLUBmHcn/hGI4grXzTxjsesaEBRG8CQwoWiP7VHvjU9UiBthDmjnQN
	 RgpdNgg8T365IAL5ZmndCHhvXa2mwpUB/WLtj/2qiJzy+J9R+YYNiDBA9KEH7Vbue0eXP
	 DXvUzw5feN2JenNFjZoahNBAVwBJ2vYyi7S6U3DIevxVp3TwwLqZsD+NuCi/CX2L94A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793612589;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=7WhTA0Y8V6vZp2rorlhZwrgj9nL0x892/MR/HRLGhZE=;
	b=OmLwl0t5Sn/sasBCfkdSlpVcCkcC8mhE00blNSpCLm2EBflKVkxg6VtUjKdVt7+JRNM+
	 czpy+WhhUPZoMquksPBFyd+FjEBJR6Baldt2aGgU2+sw/dOY5ej71wGyZa3c5AsFxnqIo
	 ezNNUT/Ix2awz1VsdWjemytP2VKDrk/yr03S3RVSZLfLBwCeFs2mr7BvEEeW8Wqnb9Ecw
	 P+wMWXIFcpO+I9FOFhBrUefAk8b2NBaL91K4GyT/ut3fGzMrWFBhbFxXkkFUF5SOHIDRK
	 Cqwl5gtZlJ2bDj2OrarggqDIp+vwo9cqE3Edq2M+GHQg27mTZb3m05tXav65hjscNWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="tJQ/U0wG";
	arc=none smtp.remote-ip=91.218.175.16
Received: from mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C25606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 09:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51C25606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tJQ/U0wG
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=R0ifyYqy3IXOuNSpfX4Jz2GTYZxqEkqpRu+RTCJxyeU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793612586; v=1; x=1794217386;
 b=tJQ/U0wG7JQj8Ka9677dCWu4wy/9Wsl9JCPVSCH7CkhRrMoKIG4fG6EhACyl3yKx8LBVLrCD
 p2dCES0dr4QV4qyVUSQLsK8IAQU8vNemS8Uu5V1kueS8JHlC1Z9DzMqlBABltFRHmomgvmGwZJ4
 6TP/pGFRR3Ula9r5GAzitXL0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 68252985a2157eaa;
	Mon, 02 Nov 2026 09:43:05 +0000
X-Mizu-Trace-ID: 68252985a2157eaa
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so6630e87.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 01:43:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx5+qBaLnsZAlYfljohGHLMHWCBoXXxI1+RttotnqmVnMNwVucWQWVb3z9SM4g2VglnkdjOq3Y=@lists.linux.dev
X-Gm-Message-State: APuU4Z/SN4kQEKtYeeoYQRhLpMs1Gn4ZoM5SiAObrBhbHhqEtOHkUS7G
	hBV9K/IRxk5UOz3EljfG6th4DlFG9xr0uTSAVTrEln80blNHvw5xKG83em6j3BCLJYoiaBxpKxM
	RJX0THLw4qiLIy/AmA4RcfmhEprzGMg5pEdmbPmaT
X-Received: by 2002:a05:6512:3353:b0:5b4:74e2:4171 with SMTP id
 2adb3069b0e04-5bfd13fc8d8mr558803e87.4.1793612581038; Mon, 02 Nov 2026
 01:43:01 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102075843.2556018-1-fuad.tabba@linux.dev>
 <20261102075843.2556018-2-fuad.tabba@linux.dev> <07d0afa8-1b9a-4991-a419-9840cf629d57@arm.com>
In-Reply-To: <07d0afa8-1b9a-4991-a419-9840cf629d57@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 2 Nov 2026 09:42:24 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwNSxBa8-_0Q6zmgqW0RGyVhpUU3xnFg3-sqqmsdL4s8A@mail.gmail.com>
X-Gm-Features: AclHuK8-iGCZpGhNLfgi22ISGBTFMIXgkMtlm2Ix60vIMu408Jz2-z6XjUn9gQI
Message-ID: <CA+EHjTwNSxBa8-_0Q6zmgqW0RGyVhpUU3xnFg3-sqqmsdL4s8A@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] KVM: arm64: Clear the VM's feature bitmap when
 kvm_setup_vcpu() fails
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Will Deacon <will@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Jack Thomson <jackabt@amazon.com>, 
	Congkai Tan <congkai@amazon.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Mon, 02 Nov 2026 09:24:15 +0000, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
> > @@ -1856,8 +1856,13 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >          bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
> >
> >          ret = kvm_setup_vcpu(vcpu);
> > -        if (ret)
> > +        if (ret) {
> > +                /* Clear the bitmap if setup fails on the first vCPU to be initialized. */
> > +                if (!test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags))
>
> Is this check necessary ? We go into kvm_setup_vcpu() only if the bit is
> cleared and we do this under the config_lock mutex. The flag is only set
> after we have finished the kvm_setup_vcpu() successfully, later down.

It is. An INIT on a second vCPU with the same features also calls
kvm_setup_vcpu(), with the flag already set, and
kvm_vcpu_init_nested() can return -ENOMEM there.

Thanks,
/fuad
