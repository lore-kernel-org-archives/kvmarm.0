Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D35820AF6D
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739359898; cv=none; b=YZ2TixHoVBy2Faz6HhZ4De9/Q22EeKtXf60OA2DqSxwCVLTmB27Z5OZ92jiyY1T5hkeaFY5vvogg+KEHPeyDLIWnvynu3b5xwk3WYrZph2poaQ7RwxgnrjA4CqgtknB75WEGMmjr4PufaxV2cXgAeHpQpSsmNSBu8IP8mtIjxnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739359898; c=relaxed/simple;
	bh=e2KfzgLwmzk5l1JnDBTAAKAkzVrUhAernehT+CJYXpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7CvgaZbqJINoqWjs64YsHAf8tMVplutmTpR0fKMNFEys42F6X5hU3ii+BBlPnhcpT+Wmw6bHKY+7hPecaFBiqcVF9mj9/gPVG2cZ+C69Gmd9LUZYt7eCoyWnJ2h+jyaxw+EojUmpFTRslFuU40vL7Cs5IWJzGiVlSQg3R31qYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sMucV67X; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sMucV67X"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ab7f860a9c6so79600366b.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 03:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739359894; x=1739964694; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6IY7v4Zi/Fu9rYdLW7DVELcSJJEpH68M/8w+jya2QF0=;
        b=sMucV67XeTf8E5m4o9ILnaf0NHjq9dhqkPnQeg1yc3lxHUJloSIm1nJzxfJzBuRXp5
         1yXi5eT1TuS8IRAumQpl1MZJiOv8esRfJTrBJ68MnNGAJQ7ZP+qvv7siTWGqlc3WcJFz
         5ymvlNnAFckXo6qqonlxcvGRCWqevnfW0dWnj5R7Kb139qCzek3ZFMEhTYrwc8jezSAT
         HDQ054lrHc15xBeacO2Mo0d1qUtPw4rs1marQI87y/GYbiisqbVT04NDRuSgMOs6h5Z4
         f1DqrCmbV+BDtLmn3IbUuGTX5LEQJVsWcB04TYlgEz7F1gTahAbnG5zuipqp7MequaEj
         qt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739359894; x=1739964694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IY7v4Zi/Fu9rYdLW7DVELcSJJEpH68M/8w+jya2QF0=;
        b=wvPyAP2M8Hm8Kx8ppllp67LGv3lO3jWeQaFf1O2afN9EBnD649CmX2tSfEr4J0MxVQ
         aouYNDVTbIzN+854RVuzpg26OBdqt00KtPRup4BONNqKY+i5kmIvc1bvQvDlutMGHruB
         JgdWaG/Ehsybm7iuSHz1kM9EvhqWDc52IFT7Vq5oI6Hl2gW1PoUVIsUXkowuhbfS9m/x
         PDK0r9RGa1IsSUahFY76ztQ+mi82Hu8vHqwBcL0piW6XenVO0s1IvayBbuJ+KeNBSQBc
         PHST6ks9crB/rvkY+ITQXPyYJk/elXn4q0gUqmY2YfGAUCL7f34yjAzfg4xBqTdOhK8I
         M+fA==
X-Forwarded-Encrypted: i=1; AJvYcCWtW/t9iWl/qPRjhThyhxoMajqAVp+wj24/5VPDMbR4NGDWN+tvCXSLBY3X0nMTqeIBAvnmNB8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxY7t7XkXp7oNr38t8ANbM3hScMnSkwkDWX58C0tgXabdNY+eiW
	pJ+Vl58hMNU9TahWCE9aj9/xMLDjExvTJg1Nv17aNAcR/L7kxesCAuRgdfmYzAU=
X-Gm-Gg: ASbGncuqBApBDfca/tvRmSZA0JRnKjtqxJ3wV2fwMxVGxNUL21ZnfNP6QtalOv5Gys2
	YTKK+IYwE9uhRi/F3n3p4TF/05/1K7j0WomLylqOvyTTEj0npz/fVfrJZOHJh81+QfNdL9zRbBb
	T/D1aDNOB9mBqSwAMFtGUsApJy02IfcNs1+cDJ9zXgqm3zbTJR31cg7RvU1Z/mM3ZB/4h0eC+Qf
	+vVx1cdaZcGr+69M+Y4TvS4OSWl4PLvd3blBbYpPCW3gNnClYvZavF5g8jfSmcLloqI/7XfG9Ss
	S2OuwUf0Xh0LYgrqoTiv
X-Google-Smtp-Source: AGHT+IE8r3Uu976/b0hVMNfiMuo5JA7dISIXfDl7r2E96RTKYYYlUfjyoNpZXPWOU+uynrV2OZsf0Q==
X-Received: by 2002:a17:906:6a0b:b0:ab6:b9a6:a9e6 with SMTP id a640c23a62f3a-ab7f34a11a2mr214687166b.46.1739359894370;
        Wed, 12 Feb 2025 03:31:34 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-ab7c3aef933sm570929466b.120.2025.02.12.03.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 03:31:33 -0800 (PST)
Date: Wed, 12 Feb 2025 14:31:30 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, kvmarm@lists.linux.dev,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>,
	virtualization@lists.linux.dev, Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: kvm: nVHE hyp panic at: __kvm_nvhe_kvm_hyp_handle_sysre
Message-ID: <6b7780ee-6dbe-4e2a-8d7f-4057e83c767e@stanley.mountain>
References: <CA+G9fYt6Cuu6=OO9w80yhJbZB77Q0qf7nzYdvjbgDbgAw6t1jw@mail.gmail.com>
 <8634gku30g.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634gku30g.wl-maz@kernel.org>

On Tue, Feb 11, 2025 at 11:36:31AM +0000, Marc Zyngier wrote:
> On Tue, 11 Feb 2025 11:24:06 +0000,
> Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > 
> > Regression on rk3399-rock-pi-4b while running kvm-unit-tests with
> > nvhe, protected and vhe mode with virtualization enabled.
> 
> I do not buy this. RK3399 only has ARMv8.0 cores, which by definition
> do not have VHE.
> 

The links to the dmesg are at the bottom of the email.  It does seem to
be a RK3399 with ARMv8.0 cores though as you say...

https://lkft.validation.linaro.org/scheduler/job/8117232#L1395

We'll test the patch.

regards,
dan carpenter

