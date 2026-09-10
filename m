Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA46837F8B2
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 02:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789008897; cv=none; b=mY6xGv514hp6fbjSKK0gto11p4BEXd4sTFObgGl6ehazk/c2nuGbwhC4W1Fs0wt1osaqdlqPbqIuFTPMFG3jO5PGTlZrP3bJdXCy7wCCUIslZleEsJZtYZ8fwmH/UJ9261e+nEm7KUhcvCv0+nz/gW4AvEY4dyQW7xOnjObZPSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789008897; c=relaxed/simple;
	bh=0CsmXKkzESsxC+tRouCw17YPGjua4+WpOUOTalus1XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDw9PJHT4bmn5RS0wsahHwrbxvggBE9fjA/zd2bhP61X7m/gRhB2YiH/N1Ue+xbVmE55i2JobcGZuW9OccjBWLXn0SiL5GPIsRbrba6Rd60qzBYADPSzBGOZEK3c9IBk+ey1rNAsdTX8JXhh4ZvNv+uc9qoKyuiaojIHNfAQ5pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b2mRVNmC; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2mRVNmC"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd38e0e5dso10150905e9.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 19:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789008894; x=1789613694; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/bkqSDqoSS4X+8RqIhO4osWZcJjlcPnaK6w17Spzl4k=;
        b=b2mRVNmCoet+zEvydPvAbFkhzwdArjPM0nxP5YOUxWWb/lLGg83ufHXsQnDewcWc5B
         0makcYorMIDY2PQpIAeVfzuz+sXNlZnDpf/LqroTYdDa+MrMvY4aEa59+0Oqx2SNdcvm
         PGzeoxjJU1jfUD0B0XnugCUcLTjT1qMGc6/4slnajqvU8ynE1HtavGm6bT/39QWx1ooa
         ZrezfmnqVTsMxk/ugW5H32d+KPu5xYtOiZa/ZPgmtAXqZgsfWmZNPNURPIieQBGaLeBw
         3F4Sb4kyzkK0hHxXfLo4KGtiIrd0ohV9cK3a9EOMqLRMhTRTlWdAWL6O4DoGc8WbzFzS
         TxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789008894; x=1789613694;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bkqSDqoSS4X+8RqIhO4osWZcJjlcPnaK6w17Spzl4k=;
        b=PuIrP+I81sFRi307o9/lWlu2Iz2HJO9s1dNiyIm69MufBgbC8Urq4eVFo2F+i1BHHc
         hLnMOqePKHS9eTpdHC+68RgDjj5hF5gUDKLod/cfXeVQ5cSEXeUQEB9kkHZBYvDopTAU
         0wy22VFujS2e5KH1k2xJceCJRC3F6CmZEgLoTCIVk+V40ClZHlSSPHDkZsxwtTu1gTJE
         NeQCktXGQGqVF0sdNDWTR8rQZQkiu8EJ46EqBqWZbknNw7yPXzb6bxCK8daseXhiP4XI
         gOONFscN/NgOx914JZriPPpvasHuUrnYelu/V6YoTuAEYBbA23/nk9gNUsPx87ulOPOs
         d2iA==
X-Forwarded-Encrypted: i=1; AKwUvBxHOIWtbhr9Y8DwC5UfNCJ4VH/lyhIroDfhpuJ5285HAAPmjqsE8sbz/8lYACNyeV1y5MJZJOE=@lists.linux.dev
X-Gm-Message-State: AFuF++kEar7c8nX7+pZ2Fh8veTwMIR/Qm5ACHiSmp+KwuxL45J8AQjcV
	UsrhCGuor7I68sp/1X1PUEBDf31vb6+YxRoSEptYbT9oUHArjWGlumaW
X-Gm-Gg: AYBFou0HUllxVk+dkrH8+xWw8wJ02znj6U0Aj/b/N2Of9jMrMH0UkotuCswV0r9uBEI
	qeHAERRePctWVt3je2iCek7quN+tnIfyp5lzHB/dlFhwnNTM/IqlcSE617s6F2KGOIPJXwSbtOt
	DkGOXj+jPvjSl6apkHD4TsYxXQrWuQAnnDt9clvo6C4QcVE+w423WZxiEa0g1Ni/xdB/PboaD1t
	jb9748atXWdmmJ8z5XQkUb47e8mMzaYwsYCND+EeVRKN+byDzGEsCVjdvdS5gLxc42qpgd5OV5P
	6eo+FMtzsbCZHS41M2wGt4s6uQW4ROAQtaN3ps9HFUKFLwaS985t+jymZjYkw4fluhc8+x/GlBp
	GfPK58tOJV3hhVc2SxhBqZ80t0JQ+D9d9fVa8BCBAtT8NYiSbLxZT59a82oGHh1saeZw4tQmoQp
	wH3UU0IGdoAONI6//5bANnjJWKzKkpHJQ9xC+CTr6meRdD4L1pqoT91cwJbmUOQ+cbfwfnouER2
	twv+P7T3dhcsF3Drubx6wLEnBTHEe18aMKsVd8OMMNncH8DjMupSH6un7FkDM+Gs+j9G3g1g7x9
	iIjeCvWCC8xmXWyUAzCZT+20EZYw2xInYrAjzS8CrU3GKqp0UkIiqu79K0rVS8t2MD7Fqq1E
X-Received: by 2002:a05:600c:630a:b0:49c:f89b:f82 with SMTP id 5b1f17b1804b1-49d2592c540mr85347385e9.12.1789008893739;
        Wed, 09 Sep 2026 19:54:53 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-b3d9-b901-0402-5aad-0ef4-88ac.310.pool.telefonica.de. [2a02:3100:b3d9:b901:402:5aad:ef4:88ac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c46b64sm33036055e9.13.2026.09.09.19.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 19:54:53 -0700 (PDT)
Date: Thu, 10 Sep 2026 04:54:52 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Quentin Perret <qperret@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix kvm_get_vtcr() kernel-doc
Message-ID: <aqIbvOvIe89_RYHT@gmail.com>
References: <20260909063156.89636-1-kmehltretter@gmail.com>
 <CA+EHjTx3fmj_fkD_ybPANyTrEApMUyBscfP4JtP-F_MRL-L=2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx3fmj_fkD_ybPANyTrEApMUyBscfP4JtP-F_MRL-L=2w@mail.gmail.com>

On Wed, Sep 09, 2026 at 08:36:40AM +0100, Fuad Tabba wrote:
> Hi Karl,
> While you're on that line, the description is also inaccurate, so you
> could fix both in one go and save a follow-up touching the same line:
> 
> > - * @phys_shfit:        Value to set in VTCR_EL2.T0SZ.
> > + * @phys_shift:        Value to set in VTCR_EL2.T0SZ.
> 
> kvm_get_vtcr() sets T0SZ to 64 - phys_shift, so phys_shift isn't the
> value written to the field, it's the IPA size in bits. Something like:
> 
>      * @phys_shift:    IPA size, in bits.
> 

Hi Fuad. 

well spotted. A typo seldom comes alone :)

I'll fix that.

Thanks,
Karl
