Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2809738E5F9
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 18:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786039254; cv=none; b=vCOLK+9hN/1CPb9IYbOnO/h+xY2xnnzqRApoEFlnpp2sIJ4O9r5s+q2LApNk4LXWKa239E+1PwykKHm2smbmLovlqS+VFohUI/Cj3xWzW0w6wvLKMOJ6cPw7zVitOubHQX9HR+GXeEdqrlbqxgI2zhoDWn4fMsrehLJBdsg5gRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786039254; c=relaxed/simple;
	bh=J3avfEfW9gW/TN5lEejRtS4N/STs0EUCkLfklwncbOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOSYAMsbBxk9+M3vHEUeoc4+qqY1djJT75maqlXa5n59ndFAFmi7yFAnef8IyvV2LRYCezHxuArG9EJd8IbhokIalkmG/bxEkY1yZHYiqeuHM5sa4NuoeB3vyF6FM1YTNkUYWdOKsiRP27lPdVFYqpIFTcFGrzi0GwgnoZvgcME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UmrjdC1C; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmrjdC1C"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954a32cf1eso13077255e9.3
        for <kvmarm@lists.linux.dev>; Thu, 06 Aug 2026 11:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786039251; x=1786644051; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RRbzzkyTb3jdfnCCyeAUeJJsqm0ppzhdGbvkGq0K/Zs=;
        b=UmrjdC1CcJ3eRUJ1O4RGNFuq7i9+Q87teIm/sywV62jbNdYEG6s7i2VpI/4cbHuli8
         eFa1hlmOkWsmIkBJB2T9e5jNSccXO2N0YagVXdTyxrR3yTJgFSVyFSy0oZxScBntJ9mO
         YhcA9pCi/PQI73fi5PMRrqo5X75ohnK4wzJRY4q/Sa0qFLNFj4Cna/+RokBe8kxcEIAP
         lGO5Ol9kX8eihuhByMcUfQw7QkWbJ+ee4bNiRQrznRXid8dzWub804pCTuGLSvLkcNEZ
         ywwuQgyjFiikAcjLB0etnK6dTOLf3V8F0x/d3uIO78wXqKHd7kfGrwmwq0ETG5SPsr4c
         BH4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786039251; x=1786644051;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RRbzzkyTb3jdfnCCyeAUeJJsqm0ppzhdGbvkGq0K/Zs=;
        b=Oe2klhUgDJ783uJcRclaYPECzwGxUPVaHTqhRfhwRsjcAfVU0Y7Xf/KArLQdwZziBz
         j7/vbwkU6h8vIaBsMXYaZvvsLdH/m4U3EV/0KGhmHReYr9WMzFlSNnsHRAfruffQAodZ
         6W8zvqIgVxkgNgWxo9ijTujjkvBEV0awuMHPgxiS9H1eRgODpOSUVUG70uJuno6oBj/v
         NArEsY+vkIQ7jKAlMMXZhDrDYhXGwcnA+GQegTce7IoS4FFMH2tGMSDEmaGxuftc1J9n
         JeEszsVvYEWXrqSXVcRgH3TbeSneANebJtptcKKnL56g0WueCSoupMTickQ+QyfAwwU8
         mnWg==
X-Forwarded-Encrypted: i=1; AHgh+RpWX86Ze+imGWHXC8w1dfRLGOYv5cP3HGRfTGRVheR5oNCJN6h1mNMR2/FkrsghnGwX/YlohWY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzG48lfxpxF07qCf9SpEIxR+fAebriEoSsP8vWCg27tgBE/4zBg
	DJpVTZPyOukyPNV4gJB2IgoYw4Sz+pj5y1fVb4l3Z0BrnYZBGMvKSeBR
X-Gm-Gg: AR+sD12m+hTe5a1kEYyD3HmOnCMNrTqnovrDX3p13hnUZS4yfRtQRu4C5BaVR9fd+Lk
	ddesOAc2cwn6LqsNLRIrGe9Ix6i5Or+2NQ79NLR40DZvPEK4pZcwaunZEPn+0u2TI6tQuKeptBb
	acnhqL1f+j61PPyipe4EdoDuVP+CQoyWkXq16aOvqn+iOZtXhYToRkTs0pvHsebNGCtO4ZQfJQL
	Vz7+lvRoXuuT3D5gBUuhpZumlnk0CR9Al2Fum/8rATfw+jiz+La79Sb0aqOee/rIKGk992uqTQD
	68J+WPj+O4oLxztyfmy7bTQj8hC3NJo/5fh+cekxoF/CnqRkdYEEk7G83bDHeR1Qmq0WgX16gLH
	BZJNhn6dNyj9DnxdjBn2X8WHLunWjdam4i3g9kWZhLFRs2K9vDfJCSIR+q2nQ/JBC7y2gTi91sY
	GsgV2Y1foy/C1mz3DopubzxD1x7pQjiGGvRpO0D8fqjCSKriLeInRYXTo+wyFxxcgawMK+9d0gS
	o9Kkjs49FBwIGGJqYFQ+BIVV4w3PtW+irSxy7jEqPuibMUcbIcWGgfdXgtWBPO2k5XfpP/iyPw/
	TJLBWsCijRG8vbiUfve+LGdlGdiymzBVeWqxTl/auGNc93+wOHnjWEepg2Fa+hRlcljHatEE
X-Received: by 2002:a05:600c:3422:b0:496:c18c:f9a1 with SMTP id 5b1f17b1804b1-4994e7cb6abmr177384855e9.14.1786039251156;
        Thu, 06 Aug 2026 11:00:51 -0700 (PDT)
Received: from MBP-von-Karl (dynamic-2a02-3100-adf9-2301-8c14-6be6-a9e6-a2d4.310.pool.telefonica.de. [2a02:3100:adf9:2301:8c14:6be6:a9e6:a2d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499541b86f5sm78547805e9.0.2026.08.06.11.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:00:50 -0700 (PDT)
Date: Thu, 6 Aug 2026 20:00:49 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, grayhat@foxmail.com
Subject: Re: [PATCH v2] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed
 addresses
Message-ID: <anTJa-VDvgCE-Ax7@gmail.com>
References: <20260806062352.93489-1-kmehltretter@gmail.com>
 <vhpuadbpqligv2pfol6wsxtwpdkdeorlq2k5ifurwgry5pbh5x@jdm5jqm57sp3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vhpuadbpqligv2pfol6wsxtwpdkdeorlq2k5ifurwgry5pbh5x@jdm5jqm57sp3>

On Thu, Aug 06, 2026 at 03:49:35PM +0100, Wei-Lin Chang wrote:
> 
> I felt the commit message needs to be tightened a bit, so I restructured
> it slightly and removed some information I found unneeded. Here is my
> attempt, feel free to use it if you find it better or further improve it:

Hi Wei-Lin,

Thanks for the review! This is clearer, I'll tighten the commit message.

> 
> > +	/* Allocate the fixed-size pointer table once per VM. */
> 
> This comment seems a bit redundant.
> 

Agreed, I will drop it.

> > -	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
> > -		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
> > +	write_lock(&kvm->mmu_lock);
> 
> Opportunity to use guard() or scoped_guard() here.
> 

Good point. I seem to forget about guard. I will use it and send v3.

Thanks,
Karl
