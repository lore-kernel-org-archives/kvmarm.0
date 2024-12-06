Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C44E214A8F
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 16:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733501579; cv=none; b=IwQZCRN41GsVOeUSODTAmcWLGR60M8I+t/uap+4jM5RfKsJ9FHh9HdBAJgIPnmeMpQ8yUn8ZFZbv4VoUaM9LN72aAER/4LzMQj/mbJlDaI4qj8WFp87mDrz/JR8LDvzbo7gaeci8jsHFKFTxEofbYGXr5uAKk4MtRv7Z3dALjfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733501579; c=relaxed/simple;
	bh=5wSw73ntuoIvHwktzBZUDX1uflD7K/iEefyxgOchGpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLVt1ONRViYPWDOm9camT+O07Up3MDogAcOY9tLglwsRc6sGdALIJ2++rrz7yRZpq0CCdlX4CNXK5oEGVy5ry2OdjnW7kjgKpofXRY2TTNwUeho2Eac+NKWcXBFfASTN3y8FiakB4yNG9jJxzp4ebUon1ylUL3wBFvm3AUStqnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=thEWSK5G; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="thEWSK5G"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53e224bbaccso2573497e87.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Dec 2024 08:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733501575; x=1734106375; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lxD5AZV9DayoSXRYg+9hzpbHGYO21ZbSkS34RH52Yus=;
        b=thEWSK5Gl7fYbLM9H+PVjV7xBgaYwzZVymPrkpeFjhIoxYbgVrDdx2jsfd7Mj5dNKF
         XloOji++oiVnXY1dw5s5/Jgbja1IxFkBUGnafZ/2IVfJt3fL2rk/2X/GP3eWyd+/X1e9
         QJECdRGfRi4LPciQoiae2m3R38fX+3TpsKKnfX/IrAByX1Z7573MS7u79bT4MsmXQws1
         5bBPTNxaP4e2IYDKQrNipexJD9liZKD2hB3NziJV0QdSsDl2sPwHp8w5jsXLneZWpNg9
         fzIl5D6KlczgAQT69f1+8lPDBOjcwaTen2m/V89nyY5Pt6VKSBHVWx5TJACZdAWkok+8
         un4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733501575; x=1734106375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxD5AZV9DayoSXRYg+9hzpbHGYO21ZbSkS34RH52Yus=;
        b=sh2sCAtVYJtO8BYjqwp0bvno/pWOZeUdHB14qdDlgzNjA2cZHNJ3Sx7XG2CyXL4HlO
         x8tKNxXXDpF/4G7ZWy+vXCjYYhIweDG10p0B1X8RoYqIZGTf3GG93UkuzsNE5U5bItPZ
         KUtN685yxP0LaAReiEF0XVI5QGgkA0tVkkwrGYWNcMey3FNH5wHnWnslbY8atRSnTb9s
         27yhfNOUN74fk1DKmL+pn7HdKTZX6i+cZlUpienrCARvK4gYgTBRLb1Egx5KEAqdSjoy
         2gyaN2S2vtvMrtm4UoB7raPdh/JtXwaryr9aJOAyq8Z9BlYnmP1WUppCLxoNWTmqNoJI
         FWrw==
X-Gm-Message-State: AOJu0YwH+Tgw1iGhSnW7WCTri7F4/2C7kj7TqTp5dVv37y5Nwu91RxSm
	Dvt376PQKeOM2DMUJt78Mr5YSK/wpR4U5yfhHXWIUYga9HhtqKLZFP//4DuB/w==
X-Gm-Gg: ASbGnct1GdxUgqu5wRd84zFTFzLsTUhCb7Vgry0Hs5Ot5rmwr0TPZxURM8JmVjnhaNG
	Gded21RbgJRfTe8kYF/CeResvaM0VC0SWBRUjOXdMrwogDIuBN9DhcPNUkqOag8pMPrcPDjloXo
	26bckBr9hKAFKSZIK1z2JENZHKJiN4GQOYdW6PRm8UC5dnG4CIxx/cIsDgQtvBB3UOJsYmjgdVb
	hU66t+7A+5RM1eSDfCTBeFzeyup0w2/QOfWo5E6/YhcZ94fsyQAPGBGNZhdK7/6HcpasLS0Xr89
	y1wzIqym
X-Google-Smtp-Source: AGHT+IGa2N7cTRtb6lbjP9CahxrYnMwp7BFPpNclv1nu7zbQhYjkfiRnsZDFOvKnxHHo3QTqnrg/ow==
X-Received: by 2002:a05:6512:308f:b0:53e:1ba2:ee1a with SMTP id 2adb3069b0e04-53e2c2b83bcmr2156579e87.20.1733501575334;
        Fri, 06 Dec 2024 08:12:55 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa625e58dbcsm258112366b.15.2024.12.06.08.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 08:12:55 -0800 (PST)
Date: Fri, 6 Dec 2024 16:12:52 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 01/14] KVM: arm64: Consolidate allowed and restricted
 VM feature checks
Message-ID: <Z1MihH-aLq6lTccm@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-2-tabba@google.com>

On Monday 02 Dec 2024 at 15:47:28 (+0000), Fuad Tabba wrote:
> The definitions for features allowed and allowed with
> restrictions for protected guests, which are based on feature
> registers, were defined and checked for separately, even though
> they are handled in the same way. This could result in missing
> checks for certain features, e.g., pointer authentication,
> causing traps for allowed features.
> 
> Consolidate the definitions into one. Use that new definition to
> construct the guest view of the feature registers for
> consistency.
> 
> Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
> Reported-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> ---
> 
> Note: This patch ends up being a no-op, since none of the changes
> in it survive the series. It's included because it makes the rest
> of the series flow more smoothly.

Is the Fixes: tag above really needed then? It 'risks' being flagged as
a -stable candidate, but should it be?
