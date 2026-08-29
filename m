Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9795B3B6BE8
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788018786; cv=none; b=XDkse9sDdTCwXlzVnOr9R7mKW9hD4QvlfFD8dm/tRejGaPRhAbqd8X7WWivw6hr7VALzfzNE8Gab29pEJWQMrp5drzg/NNIvU29B6cScEBz6dxh2SUFhUkoSZ+V4lUYo7QUW9W2yfms99WEBcITcmU3rsbWmxI44nTRvRf+KyCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788018786; c=relaxed/simple;
	bh=u/QcdMTFyvL/N8kNdZkXvPw5nH3ZXvrAXroaB5kwYPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNDW8xC5ABGiPYF8Ui9eZjthLLpO3Pl17yRUo9SJw35QKPbs+J80oVSiuP9PsfhVscukkAdgqlP3/fNKi8bpbHN7sUQ9NcSqrlJSNb4lCacw1FdB3Ll7rWf3fpbz2eWaUzAoTVwCJxrBy/juQAE8M8YMpwppsZxszwbq/Xj+OEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hzV/TL4q; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hzV/TL4q"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f96c5b722so1195198f8f.0
        for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 08:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788018783; x=1788623583; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kqxt2pJA79TUQhxHKJFLWKa2wf0Abmgu0fLyjHQBRCk=;
        b=hzV/TL4qsnSP7lK4gkb6oFu9AD09cdbHexYN+1ES4w7ziilhB9MHqFyB+iqya6OrT/
         C8G2qq3k+86aHb+d2UJfmn/wvqR0oidqH0ApFRv4IRYiHSwyQIQjqTb4dKIi3NJFnlWC
         SYfBLCIHskG5szWleFfkxY++rP9boYs+ZHWEQUQKRWdJk2T54bU7aNXBTZdROLPPB5pQ
         0mGXoSkZXva2QzjPW7OspuCCFGwGE8XZuzHXXvup6DoErFAy9QvOVQZprNgKGVmrsDgk
         mHLj4LdikYDW0TmMdD0s6kLfWcEbg9bLAOqkji8f+TO3AxyC3ybjP6rVImJe3OQg8o1x
         rgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788018783; x=1788623583;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kqxt2pJA79TUQhxHKJFLWKa2wf0Abmgu0fLyjHQBRCk=;
        b=ipkRJVkHF+bP7owepuM7DMAagdWMUcasBJNHywStXTQY0U8G/wkXdmRYI0E2sGWpXy
         fsTeC29m3jmEIYTG/CgPwhOWVqMTkydw5vcoB+3rgUOHa5YaEx1y5X2Cq8YCYmHWKfCX
         eswMr7waYvimOHhA+QagtcTLxn8csX4WyIBivdQdPjEY/cMhtmd3Ptjvsl6VeFCxnnZc
         Xnh1LJkgr0fE8FhCGm4P8SrrsvCmy0lI6N+pyF9/rj5fRZWSluu5cBDhbojtQYs/wvP4
         aOCmXYwcBTJxX/DFaT8YCOPRDCsAzFLEv7IWaL+MKV353Km7KX4Ew+D4g87ji8ks7/Mk
         4n5g==
X-Forwarded-Encrypted: i=1; AKwUvBzOPqETyWUpb6QJILnTToBy26tHz3GHD2Do6kgeESDMnEXhZVHjJr8RsAmyhjuLBPnkRo8+miw=@lists.linux.dev
X-Gm-Message-State: AFuF++mnyqGp77lU+s8W/6+4z6hEZfyafx0WTeNyJsYIlTr89UOWVxQH
	S7RgNMfgOP+YKjxCXbMi62+Fpe3J1qsJtf5ujXXsFgLtxVENNH3n6RSt
X-Gm-Gg: AYBFou1z4GDM2LmnW76jEAXT7UD09gpTfHZOcnAyUipchJW2adn96MsvHFGGtMSLeRS
	+azU0cqKXYhTHrYOMPuaUrEsaKaVcXlG4fEAkI2hSF3fQazF7CRJ/xFhUJ2ulhheblYQFbf98UH
	8AziTR4CfeOcW1f8Zlf+zj5l4dlvgKcCQfXsZvlwQhsLjjS9SesSzsn89CuwiiN5FrYDdlmFNLd
	/KJJUv6X8p9K1phniGM8Y+JSQwcDjz5/KfCFGCLNiEpdiMIVao21LNQq7DYxzwPQVBqItVyjAbF
	n7TrF9c7o+84BCZkI/W4jdq/op7iocTmUnNwR1Lcs+BrG6a+wtQh4TUSHjAAEXK5P8igd7MbL6D
	Bcsf/4Wi6FdP77wPPrCw1Zjai3K8igJL3nO4lbTdRHktEw3R8O82w8DbuViYK1/8ncgxxLJvDGy
	930TLd3Q+MJPwOAq8UcY54RiicqGP2sebSL8A1NsggxsTzey5fMVWxOop3RyxxAaw30m85jvspc
	1ubeKCtZlOuxsDb+JYtQl8EeZFsoRct6qwtqip2UjxGOjJkR2SjEB1zXEXSN6eIeVfOLlV6Ogou
	WIAt3dG/M4E6QQFCpSgLLnxtt5Eop7KS/BSuaP9Mb8dVE9/WoOP0Kxw9+EoQ6fi5CmYIzA==
X-Received: by 2002:a05:6000:2287:b0:484:3310:f399 with SMTP id ffacd0b85a97d-4843310f41cmr3869418f8f.26.1788018782440;
        Sat, 29 Aug 2026 08:53:02 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-ae86-1b01-80e2-8851-4221-68d8.310.pool.telefonica.de. [2a02:3100:ae86:1b01:80e2:8851:4221:68d8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbb20122sm10864679f8f.20.2026.08.29.08.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 08:53:02 -0700 (PDT)
Date: Sat, 29 Aug 2026 17:53:00 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Return -EINVAL for an empty SMCCC filter
 range at base 0
Message-ID: <apL9jzg-KM_n3Vv2@gmail.com>
References: <20260829054856.70549-1-kmehltretter@gmail.com>
 <20260829054856.70549-2-kmehltretter@gmail.com>
 <CA+EHjTzQM0bf1x2X-Y+eMmUHSYUmJXpt_jQ4Csu7JpkjtFT72Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzQM0bf1x2X-Y+eMmUHSYUmJXpt_jQ4Csu7JpkjtFT72Q@mail.gmail.com>

On Sat, Aug 29, 2026 at 04:04:01PM +0100, Fuad Tabba wrote:
> > Fixes: 821d935c87bc ("KVM: arm64: Introduce support for userspace SMCCC filtering")
> > Assisted-by: LLM
> 
> nit: this should be `Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1]
> [TOOL2]` rather than LLM
> 

When I first saw 'LLM' in a patch I thought so too.

But it is now allowed, see recent discussion and merge: 

  https://lore.kernel.org/r/87qzkuahlr.fsf@trenco.lwn.net/

  816d9992d9ed ("coding-assistants: simplify attribution")
 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Thanks for the review and also testing!

Karl
