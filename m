Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01E733062
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742831304; cv=none; b=Dkf4V4h84IATiV6Nwp5IJBBMsxV8SZg9q+QDqpky01nInEqj4UNteAagQ3suwigVjSnFj7tsklCcZfBpJvP8aLAwkDvFl2f/rGLktsRw6DN9gGWpg3KBAUCF0j/BM1WLouMwiA9GZoOzy7sWuzttqaQnS5phrR86AMo5xYYU++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742831304; c=relaxed/simple;
	bh=+wpFTG+SwBnhnvH78ViBaMrd4NWDi/4fRbVDO0SodlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5abp/RYmrGcSd4vSJScSZL5ycNLHQwFe14rRjgiB3oKBNTXvaehD5zZVfzU37NbaaJ6DeN6SqpAf3XQVLlfyrh2+4fpGwMS88D2km6F7gfoC4VvpKGzW2+EfB1x+PIl8ApmUkdCS7p+NvPz3MrsHdWpmuy2Nkh8WuHPH/1WBV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WQmSpaIj; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WQmSpaIj"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43948021a45so38167905e9.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 08:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742831301; x=1743436101; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LrMEg2SBRPufHHPsPTxdKBRIozyqsnf+0fw9wrne1Kw=;
        b=WQmSpaIj8xhpanJupeyIotCa2lF3OodEP7zCgI2xjrNv3uoL1sCi2M/R2deKWDYNgS
         BRletR9nD9lA8g8bBq4bWx6+6hIdXogLhHwak8+UbAW1UOjxT2gHG2D5pFmhTSM95Ik3
         orP0mbgI0JWDfSwjwAmDqY99TKyGIAPbD1Ya9zjV3H3936IvZTynVkNtvHIanS0aVB8m
         8IYLszjmYu8AL+wYTlG5usg3Vw5CXFhk+A6xqtN62EYIg5WeEWIz3tBD91LDL2q7KZWz
         t1YQURbDu++kqANkC0rHdXn/1O5qTQoGSAhGhJ5EzqXlSRKaklqVLz9FgYau8vEhs3Rx
         4pIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742831301; x=1743436101;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrMEg2SBRPufHHPsPTxdKBRIozyqsnf+0fw9wrne1Kw=;
        b=Z97/i9tHcWH9CY1PMNuI1a77vobf5oSQk3BNeFzqGkka040/6O80ywPhhsxmhgqDMt
         M4ZI11H4lpzThtiR5Bzw18MM1SBVSiMfaahY6Tz9yKhjqXLSPyuVkQ6oiasn49/CUUC4
         2SzluvjZ97K1qSm/k6/t/2jkbY32YnAra5nUmd4g4TttSh5rYal5fS7cV2zA9xRWHcCN
         UZVZueSkV5WJUNlBTcUmqwt1a3hfrhhFzkdg15ydf3GmEgJ2od0zYAJ6jTujIdyn2TT+
         rtyDFB8GN5aKlt2pGmpXFK0HZhuMyb8LaFlDZ0sHRsJPTlVMH1q0zRhf3JCOPAQAP0t1
         mlkA==
X-Forwarded-Encrypted: i=1; AJvYcCVzKkaIVPEDtcjL6XFUsd5XNB9hD7D0A1lU2uS/nG3hVkcHF8fNJsJDQmk+Vtwv7qOsCDsWcrU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFNwVtmh4IipJgIrr8dl9KXOV0NOjjCBv7lfqYelCT3oDNRJxJ
	H0ZrZlP3p1CVwG7WOLEoJIRfy6UUd9gKdYzBSDkopOOKtHWToSs4TTiq7zA5VmY=
X-Gm-Gg: ASbGncsIMo3TOCkULcjetNdhspU7LGxsuVFhrqfTpe7bXd3+gdOzR7Gq2USyFD8HhWo
	2oZtV9Voxe6CdO2rkt0tAD4oFPdSTBPHjsYJdctBQHCloQ4c1r7CxyVRHUPpWyUxfhj/XbIMulS
	FJsz8YVLGB06OqTXs3Z6IIVtUl9xjHhuYqe7F8VEc0Xn8q7jc8FoqI5vZxXg4DBgHOAWmyQInyA
	btCLoIx5KfqEmyMGjZ/Zq6OF8/FRW7qZDoB7xEZl2mClj4M4HLTqpY7kqAasAngS/MaohQfb8rZ
	DG3AroVFJUROVeld+6o7zRlycHunFiNpRbVVrVvVmcLSAoOfLNgEYQ==
X-Google-Smtp-Source: AGHT+IF4HKRqDp7H68XcsGcdXR2R+pX/n70fM2CJTR1c8n9FwVMwhpldYszXcap+M+tGB315WPIqBA==
X-Received: by 2002:a05:600c:19d4:b0:43c:fb95:c76f with SMTP id 5b1f17b1804b1-43d509e9eafmr116532925e9.9.1742831300985;
        Mon, 24 Mar 2025 08:48:20 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4fd9e960sm123514055e9.29.2025.03.24.08.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:48:20 -0700 (PDT)
Date: Mon, 24 Mar 2025 15:48:19 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: eric.auger@redhat.com
Cc: andrew.jones@linux.dev, alexandru.elisei@arm.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display
 'aarch64' as the default architecture
Message-ID: <20250324154819.GA1844993@myrica>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-3-jean-philippe@linaro.org>
 <1b0233dc-b303-4317-a65d-572cc3582b8a@redhat.com>
 <fcb7894d-51e5-4376-b32f-4cb9eb94b573@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcb7894d-51e5-4376-b32f-4cb9eb94b573@redhat.com>

On Mon, Mar 17, 2025 at 09:27:32AM +0100, Eric Auger wrote:
> 
> 
> On 3/17/25 9:19 AM, Eric Auger wrote:
> > Hi Jean-Philippe,
> > 
> > 
> > On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> >> From: Alexandru Elisei <alexandru.elisei@arm.com>
> >>
> >> --arch=aarch64, intentional or not, has been supported since the initial
> >> arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
> >> "aarch64" does not show up in the list of supported architectures, but
> >> it's displayed as the default architecture if doing ./configure --help
> >> on an arm64 machine.
> >>
> >> Keep everything consistent and make sure that the default value for
> >> $arch is "arm64", but still allow --arch=aarch64, in case they are users
> > there
> >> that use this configuration for kvm-unit-tests.
> >>
> >> The help text for --arch changes from:
> >>
> >>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
> >>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> >>
> >> to:
> >>
> >>     --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
> >>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  configure | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/configure b/configure
> >> index 06532a89..dc3413fc 100755
> >> --- a/configure
> >> +++ b/configure
> >> @@ -15,8 +15,9 @@ objdump=objdump
> >>  readelf=readelf
> >>  ar=ar
> >>  addr2line=addr2line
> >> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> >> -host=$arch
> >> +host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> >> +arch=$host
> >> +[ "$arch" = "aarch64" ] && arch="arm64"
> > Looks the same it done again below
> 
> Ignore this. This is done again after explicit arch setting :-/ Need
> another coffee
> 
> So looks good to me
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks for the review!

Jean
