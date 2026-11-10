Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317921;
	b=ZyHta8JVy7rLc8kZ3/iG7dZHxZUz3/XCtQKr0SySnCctpuQnid0CiW/93FPnKzphamWt
	 S2isxaPkOeQfsGuzKK4kSSFpiDqaNhbtB6JHbj79J9RmWD7nE7Hzwah158j2EJDCyvtmq
	 xUdRWTxFRbK5THCM75aiqKl7PnxT7uGRHHdXv7LOGge6ZuNDizsPoEAianAkPIKpQQLlY
	 I6pZwfECIUAwPnUfQwmSgaWQX08u96zRj4OVeQtmEcx5hfpaQVwfOWkIlNhIvuQYuh4hN
	 KLfdALj/Ln1EAtv5/WMQTwmxPWQKc/fq6QyF26ZhGVac1j2V/xACtpkI9PAtDtr/opw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317921;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=s3xh1OPWMSdcA09iRqpCvbZacGS5qDw/BGqF7ZNYNM8=;
	b=Nfa8XJpNNudEH6pysOwuA19+FvfS+zIJEUVx9CDdSV3ici1QvTrzxy2X1IGmnydRq9HJ
	 x9AyE038wx7NFG0WZg8ESUCfiDuiYA2R6tHi/gidPxzoadopxbYnFzKpXzdaI6MT1qwKD
	 5TVaBZDtlIFK11U1ZRDANYZRc0fd6LIlfySMJCdYJYXIUyHXn44G1SAu125nK6D1SYxe7
	 1IhL9SIUlQyuLTHNpjCZMLSv1dATuHTvraDLKjJ7HNSfE5XmdTRynyuWke4w4gMB+S/2L
	 ynjYgSxRirQpmflqfClDOE2B4wtJR30Clzi+576Anvmwkt7ufBzDzpScuf114XQNJGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=cryspen.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE99606A336
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 13:38:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CE99606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryspen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so15371395e9.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:38:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794317919; x=1794922719;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s3xh1OPWMSdcA09iRqpCvbZacGS5qDw/BGqF7ZNYNM8=;
        b=MQEC8dLE5kHTqKUCuqqJrUfwJyvPxsjcx1HW7fSwlmSe92INV58iYwpU+xJ7/2YOS0
         Ib5pXweMUIR3KhJKxMs19P5piVOHPbEtcNbe5jaS9/I8Pqg0TQgHIWXx2bnDDDC2J+Yb
         h4rkksqY8Ocmcch5F2esdbFHburIG4KrJODEXYmYKGZn3WMXcMqrNlazMoUuSvyBKAtx
         5L93KLtFdxWYhnp3dYY1HgDRH9R4oCSme4AbfuFvjrULs6QR6DqPDJd4orSvXOwhvNK3
         thtR11BnQAJmRXa44MhuL+5gLjurKUrJeA8fg3o+Ql/n03h8yb62Fur/n3Gr2lzjsyda
         LM4A==
X-Forwarded-Encrypted: i=1; AL+hErGjp1xuj+zo31MwyXFTz8FLnZKEh+BFMwgW+y4xpPqpy9oU/YHgyx7ToWAP3p/ez35iT9dYrfI=@lists.linux.dev
X-Gm-Message-State: APuU4Z9LsGR6CMR8UtoXwPSW/D8GYAlqbG6Lt+E7ekbKnOTZTD/E17Ln
	PjJR33+qsU7feshpenZ+pcubQpJq2/3h9Fnw4mMCb/OWre7If8uzXX0J
X-Gm-Gg: AYBFou0m+3DcJZUZOPilrJ3jAUCCK9fQz3CrkkxcCZFGkU6Wk9CgSPD7oQrfhpL3zZQ
	V3vyfWp2Z0Pa9Rg83+xDNWVQ2WijaGNZ8rBOOnwfHJKKDRGyuMl4atdn52JrkJ7kdSdC9Rv/W93
	Im4OMocPAISKtn1Lzq+irQ50HJhR+SsgNYK7jZmtPMXqgT3UaEVAsTGiRfhE3yRy7365OvVqArx
	f3uOqJ4hgaNw46DK3sLttelnN7mYL3nBjOqT9jvg2SaI038Fxe9FdtVJ3B7QNjDPFFx3v4CcqBR
	pWY80KidSZR7y03veVnOTBDWP4vAK7A/4ryYAcS4/OITBtomaU2nydPZ32UxAlY2nKohGka97DO
	UWswBazUAmCq3Ot6QJf7OomFfXsnf7LgU32IjhcN8ygZuRnAzkDwy/l6KMF2RFwF1dO95mnTCLA
	jSX0vOkH0SnvXiI61Gukdgu29aDrI/AT7xv0WsN0UoJ7b9iKh/xIZiEd4mwMzGh0wwPvK2xiZUM
	OrgUN6bvU36y9Kcdxhb9oRhhXV4U3ZXc944IJeAbsq8zvwaQ1Y0JbgcqViM8jBNv2/YJJ581cL5
	jcB3isxyDjhYLsoOvYvxf/SaQevwmavfVvRq6PQSRMKu1eRTlP+L+1MFks6bm1Y+ZEXa/LGxfvm
	LFvbgIn77jJFnoqwFxMhApNvHh10nL946se+AvCB2djNBn8/MJdw/dsdQoPIy9q2c
X-Received: by 2002:a05:600c:8109:b0:49f:ce78:3562 with SMTP id 5b1f17b1804b1-4ba02349484mr41901935e9.19.1794317918793;
        Tue, 10 Nov 2026 05:38:38 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835c37bdfsm5292609f8f.22.2026.11.10.05.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 05:38:38 -0800 (PST)
Date: Tue, 10 Nov 2026 16:38:34 +0300
From: Dan Carpenter <dan@cryspen.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Carlos =?iso-8859-1?Q?L=F3pez?= <clopez@suse.de>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Jackie Liu <liuyun01@kylinos.cn>,
	Christoffer Dall <cdall@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Reject ITS_REGS offsets above
 U32_MAX
Message-ID: <avMeWguO2gOTX8Bk@stanley.mountain>
References: <f4b5c3247f88b9c469758f8e14a386364332f9f4.1794251681.git.dan@cryspen.com>
 <86wlql0x5t.wl-maz@kernel.org>
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
In-Reply-To: <86wlql0x5t.wl-maz@kernel.org>

On Tue, Nov 10, 2026 at 10:59:42AM +0000, Marc Zyngier wrote:
> > +	if (offset > U32_MAX)
> > +		return -ENXIO;
> > +
> >  	/*
> >  	 * Although the spec supports upper/lower 32-bit accesses to
> >  	 * 64-bit ITS registers, the userspace ABI requires 64-bit
> 
> I think this is going in the wrong direction. Instead of capping the
> offset at an arbitrary value, the infrastructure should be able to
> deal with arbitrary offsets.
> 
> Could you try the following (untested) hack?
> 
> I also don't think this is worth a Cc stable (the worse case is that
> the VMM accesses an emulated register and sets something nonsensical),
> which it can always do.

Fair enough.  We are in arch/arm64/ so casting a u64 to a pointer and
back works.  Except for these two, the other callers pass values which
fit in a u32 so they aren't affected.

I'm going to remove some of your casts which aren't necessary and add
the uintptr_t cast back.

regards,
dan carpenter

