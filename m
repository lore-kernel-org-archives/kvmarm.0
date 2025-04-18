Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CF5202C36
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744988924; cv=none; b=nKotSazIgaSq/fqGneepHmHXZSlU6xcHjVaWhtp+ZbzTYaeg9bVGp3Bq5dRQgYGNCDLpFff0b+pkcqgD0cYrLRmE+ekCU3yYafL6DzD970ZpDFR+bGv0CUz+52f0dBNHeOeN8lB3OE0lqc4lJCezFRRZQP0QInwFldnYowAkYhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744988924; c=relaxed/simple;
	bh=833Lov5OrGShT2sPcmJuHqNCUoZcqgQRSOcAWmZvBtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WjYmtNoF1Ubf6idbp5quuQPV88snCQQ7rixKSXYhmrEYTu+0JpGtmUz8DoosemCecHXmwGB32E2X4ptYgGHTapZmKN6u0O1WZFFcnKLKXnLKN8B6hHSzYdAr8O36HNmUcOmdr1c20+sNzy+ilgizkIqjvvskQTcFqdYBuVWpzDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OKwj6tRM; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKwj6tRM"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2255003f4c6so24756205ad.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 08:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744988922; x=1745593722; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xXrHi2dDhsHjFRrFFlLx3951AzAuiByzthX8mF+kPRc=;
        b=OKwj6tRMkQIOCEzqPCHexXy/3q4QwFFbaobmd4lekepLM7xvXsGtiHe+4aFLXske+7
         cvUON36Wl7PVA325+i/3DV+xXZPNEEZpAbWZ9g4+DqyNbYyGxi91DkSU7Oa3KRfGHri3
         kIzCUiHnZSQIRcdBkTvyLz7okuJfsUb95gYsqwbQtWU+emejcu/spz0CmmohEsM4QLCI
         iVhmJXiRJjbKM04eSY2dmL1mX0Xen8Sh1sUiw7SWSqeaPQfkLFALxkNjwIv8yahsWltZ
         1R+kdpi1SJV7eBfMUzGRnRChvTRW2hMH8+T3+8/JLZYH6/nQK2aHgY5HxWsG1jIqT0qf
         yqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744988922; x=1745593722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXrHi2dDhsHjFRrFFlLx3951AzAuiByzthX8mF+kPRc=;
        b=AratIAuIaKTKWgmRoUmyjq8asJSaQ5rXvHepEg1aBfIJ6Tn1NWbOYOXrwgEfqSkrZ7
         CWHoJRV+e4rzXlkXbeRwc1PUNQyDwr4YEDaHWTkdJri3AcZ8+zF7rLPrDetzDww1JDpE
         dxoWlPEa4SkXSmYOPfPkDMOq5nEVTMumGBmb3frp6y0XGe9VgZM1qt9NSLrqlf6dUJVW
         p/5YcSV3I7HltmwkfgFlFp1zG0PcuT6EdykL351seDCVi3s4QIe6L716Dm9+G8VLFhnt
         sKDOsoElE7u6DoBRSpI7ylI30eYFNuniVQkdlTlTw4ZkrZ/fQzZBOAuh7m/DGdOYOt77
         BObw==
X-Forwarded-Encrypted: i=1; AJvYcCUIcEkPYReJCv7L94crnNmPu5sgjvC+Opn6K0aIuHDl1BmxSuAze92mZ41beIQdVVgy2ywT0EI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwKVvaIiGg4y12rKyXqFnTuFMisBymG3uQ9SwWwWFT3h10zlgj
	OIMyjs4nocCYy3yK+zhgRAKziha7PTMX32wYg1eaqyuQcD2ADfTp
X-Gm-Gg: ASbGncsXyzU5pxxASIF2z/tGzQh1sKoLic7dw1UwHwhVjWogvmJDOOPmsWmIs7kj7Uq
	D52OrxxT9T97x1ZNNNPCqXjV4beB/c2WwBrPZ6qdKKu+mjCVCw8c7YWeiVqAQYtBc/ZwIVcNwdU
	DDS+qx9DhWpEq19B7WYq5y3sRq9Q4rqLtemhgsrgCq+iNvhXEvwi1Kj1RFcP2W2QCOn1+9+n/1S
	dWxWtxLmPBumoy7TuBUFPELQf0F1sjQTkvBhz56aUdczUkRgXDIJaYmN6hJP26p/0qa8jkbDjak
	1FAufE1lRsOtzjHVS8XGXdk5RMZ9RC8gEEvhbTuo
X-Google-Smtp-Source: AGHT+IFgyjtFyh0D1cewNDh4KCf3omEopwXw/CgC9qM37WkDXknCiuMsdR9x6yE6lYdQVJp7loAorg==
X-Received: by 2002:a17:903:3202:b0:224:c47:cbd with SMTP id d9443c01a7336-22c530bc965mr45650025ad.0.1744988921670;
        Fri, 18 Apr 2025 08:08:41 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bf3fcbsm18016695ad.78.2025.04.18.08.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 08:08:40 -0700 (PDT)
Date: Fri, 18 Apr 2025 11:08:38 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Luo Jie <quic_luoj@quicinc.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, quic_kkumarcs@quicinc.com,
	quic_linchen@quicinc.com, quic_leiwei@quicinc.com,
	quic_suruchia@quicinc.com, quic_pavir@quicinc.com
Subject: Re: [PATCH v3 0/6] Add FIELD_MODIFY() helper
Message-ID: <aAJq9mGswYsnAOS8@yury>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <86sem7jb5t.wl-maz@kernel.org>
 <0c97c659-bd28-45e0-8537-d9be2637cb22@lunn.ch>
 <86mscek7h3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mscek7h3.wl-maz@kernel.org>

On Thu, Apr 17, 2025 at 06:45:12PM +0100, Marc Zyngier wrote:
> On Thu, 17 Apr 2025 18:22:29 +0100,
> Andrew Lunn <andrew@lunn.ch> wrote:
> > 
> > On Thu, Apr 17, 2025 at 12:10:54PM +0100, Marc Zyngier wrote:
> > > On Thu, 17 Apr 2025 11:47:07 +0100,
> > > Luo Jie <quic_luoj@quicinc.com> wrote:
> > > > 
> > > > Add the helper FIELD_MODIFY() to the FIELD_XXX family of bitfield
> > > > macros. It is functionally similar as xxx_replace_bits(), but adds
> > > > the compile time checking to catch incorrect parameter type errors.
> > > > 
> > > > This series also converts the four instances of opencoded FIELD_MODIFY()
> > > > that are found in the core kernel files, to instead use the new
> > > > FIELD_MODIFY() macro. This is achieved with Coccinelle, by adding
> > > > the script field_modify.cocci.
> > > > 
> > > > The changes are validated on IPQ9574 SoC which uses ARM64 architecture.
> > > 
> > > We already have the *_replace_bits() functions (see
> > > include/linux/bitfield.h).
> > > 
> > > Why do we need extra helpers?
> > 
> > If you look at bitfield.h, the *_replace_bits() seem to be
> > undocumented internal macro magic, not something you are expected to
> > use. What you are expected to use in that file is however well
> > documented. The macro magic also means that cross referencing tools
> > don't find them.
> 
> $ git grep _replace_bits|  wc -l
> 1514

FIELD_PREP() only is used 10 times more.
 
> I think a bunch of people have found them, tooling notwithstanding.
> 
> As for the documentation, the commit message in 00b0c9b82663ac would
> be advantageously promoted to full-fledged kernel-doc.

The FIELD_MODIFY() and uxx_replace_bits() are simply different things.

FIELD_MODIFY() employs __BF_FIELD_CHECK(), which allows strict
parameters checking at compile time. And people like it. See
recent fixed-size GENMASK() series:

https://patchwork.kernel.org/comment/26283604/

The _replace_bits() functions return fixed-width values, and intended
for: "manipulating bitfields both in host- and fixed-endian", as the
very first line in the commit message says.

Those using _replace_bits() for something else abuse the API, and
should switch to FIELD_MODIFY().
