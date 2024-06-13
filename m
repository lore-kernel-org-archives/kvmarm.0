Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5D814262B
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718275855; cv=none; b=qu7EYqstFmCzwZzvkwVDJt2J52O6juBSnCRFQEAYPRr3CJh6/UzAMpfsM7Wdf/AtlkxdPvAJIKrnRviE93zB0TRNA3f8bEeLEcYb+9Ywpblyf5gKNruvuE6R3JEVu4cgHtfzrZwQJ1dyAIfQuQdqo22bzO0awYpcWc+ik5Nd2pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718275855; c=relaxed/simple;
	bh=UgyBUaw5Cfb+8mR7p+p9qMbx6BdW9rHq+TZllqNkmHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjqFJCJSkupfBYJQvvDBe961yX2v7PvE+lFppW8itD8xuTYvJQrnbr80N/VK3U/k1S4XpSXDhg7hCJkYyXX6wRFec8UL/bveyAQz+Elx+aHt9M6O1A4C+xyg7zARGh9GyEL8qZpyqscj5QG9kFqQBN6dFCJWop3/47UPU0wak3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r6GkdD8Z; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r6GkdD8Z"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ebed33cbadso7925691fa.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 03:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718275852; x=1718880652; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8BVG4kRdfLOofP57LybYLwKmto1z7Z4ok3Ssg9M2l0=;
        b=r6GkdD8ZZiDElRtxKLLusDjEYVUAjxKb68iWmIQSypkiTK7PFu+/poi/bBMCjGdWYQ
         753ECo5O6mh73Yl93/nzNL8Bd0q4PyUQ0m4E85Bg5RFEknDcFyJJK0jBwhvGB00Dgd7i
         fkAUJ8M/TFQJyk7iVJObEokkbKNX6OCLtM3WKohIWclFgLtnjsCdqjU+HfmD0JZ9Uqxh
         xFKF/PpnykJ6jQzl1LY2pwlndFoGiF56q6VnCfm4NJiOS+4dmahIMVzGahutPXjuPnBk
         nJJCf444QEFQRVbiktChIpMeWwuOAtB8EW8GxN9BQo1OaWgIGdCVrEvSKkOGsehKuXiG
         GNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718275852; x=1718880652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8BVG4kRdfLOofP57LybYLwKmto1z7Z4ok3Ssg9M2l0=;
        b=keHj649GY67mQe/mBbuLjIxbrwBxHmVncObksjsI7ck+rmLCu1Xa1NTZYmQ1SQyxjQ
         npFTVpE+oyzGdePVwmz248mBkPUAenDZsjT8rJIFvR8qFatHsLlZDgaktc3dz5+s7/fK
         PJlaik0/nLGGM+TIYXm6Ov3pT8s04bltbxbGCTwajCOCNeJIhqY6kKHHkxjHRezaw81v
         +htthyfx7AFGmgU30Lp/fTl738uhlOitDO4IKmkLnCPiaU+B7jjOYG0wR0VyufnoPzK/
         S/eCheKE84d3eqwE5atArqzen/gsCFaR/QPVJZ0xgqjJeCDJubCndi/GXzfavdFlPeoi
         0Ohw==
X-Forwarded-Encrypted: i=1; AJvYcCW841J4livgyAPYb9p9+XRVcbZflmfnQhcd/VN7TBDO68uh9sAiNK67MsT1BShXiaph4Fs420+zHSbLadHcEEWhfL2OoE2d
X-Gm-Message-State: AOJu0Yz3xBZKmZPtM1Q/jPBvjFGvJceeJqN7VfwWaL96u0YinuBdjsb3
	px1gF0R13OsWqhS7xhy5GRavSvpSZfQb9/j9K04mqjisUr0+bVVDBheEybtvPig=
X-Google-Smtp-Source: AGHT+IFHavbOr+OgWlX2a5b/dvGpv+Y/52aYQqWXG4No5o2I0ST7yMd4AjYSJZeNAegwsKQiKBFEvA==
X-Received: by 2002:a2e:681a:0:b0:2eb:db25:a68f with SMTP id 38308e7fff4ca-2ebfc9abdf4mr25206351fa.52.1718275852267;
        Thu, 13 Jun 2024 03:50:52 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72ea3b2sm763316a12.55.2024.06.13.03.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 03:50:51 -0700 (PDT)
Date: Thu, 13 Jun 2024 11:51:07 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	peter.maydell@linaro.org
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
Message-ID: <20240613105107.GC417776@myrica>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-3-steven.price@arm.com>
 <20240612104023.GB4602@myrica>
 <3301ddd8-f088-48e3-bfac-460891698eac@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3301ddd8-f088-48e3-bfac-460891698eac@arm.com>

On Wed, Jun 12, 2024 at 11:59:22AM +0100, Suzuki K Poulose wrote:
> On 12/06/2024 11:40, Jean-Philippe Brucker wrote:
> > On Wed, Jun 05, 2024 at 10:29:54AM +0100, Steven Price wrote:
> > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > 
> > > Detect that the VM is a realm guest by the presence of the RSI
> > > interface.
> > > 
> > > If in a realm then all memory needs to be marked as RIPAS RAM initially,
> > > the loader may or may not have done this for us. To be sure iterate over
> > > all RAM and mark it as such. Any failure is fatal as that implies the
> > > RAM regions passed to Linux are incorrect - which would mean failing
> > > later when attempting to access non-existent RAM.
> > > 
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Co-developed-by: Steven Price <steven.price@arm.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > 
> > > +static bool rsi_version_matches(void)
> > > +{
> > > +	unsigned long ver_lower, ver_higher;
> > > +	unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> > > +						&ver_lower,
> > > +						&ver_higher);
> > 
> > There is a regression on QEMU TCG (in emulation mode, not running under KVM):
> > 
> >    qemu-system-aarch64 -M virt -cpu max -kernel Image -nographic
> > 
> > This doesn't implement EL3 or EL2, so SMC is UNDEFINED (DDI0487J.a R_HMXQS),
> > and we end up with an undef instruction exception. So this patch would
> > also break hardware that only implements EL1 (I don't know if it exists).
> 
> Thanks for the report,  Could we not check ID_AA64PFR0_EL1.EL3 >= 0 ? I
> think we do this for kvm-unit-tests, we need the same here.

Good point, it also fixes this case and is simpler. It assumes RMM doesn't
hide this field, but I can't think of a reason it would.

This command won't work anymore:

  qemu-system-aarch64 -M virt,secure=on -cpu max -kernel Image -nographic

implements EL3 and SMC still treated as undef. QEMU has a special case for
starting at EL2 in this case, but I couldn't find what this is for.

Treating SMC as undef is correct because SCR_EL3.SMD resets to an
architectutally UNKNOWN value. But the architecture requires that the CPU
resets to the highest implemented exception level (DDI0487J.a R_JYLQV). So
in my opinion we can use the ID_AA64PFR0_EL1.EL3 field here, and breaking
this particular configuration is not a problem: users shouldn't expect
Linux to boot when EL3 is implemented and doesn't run a firmware.

Thanks,
Jean

> 
> 
> Suzuki
> 
> > 
> > The easiest fix is to detect the SMC conduit through the PSCI node in DT.
> > SMCCC helpers already do this, but we can't use them this early in the
> > boot. I tested adding an early probe to the PSCI driver to check this, see
> > attached patches.
> > 
> > Note that we do need to test the conduit after finding a PSCI node,
> > because even though it doesn't implement EL2 in this configuration, QEMU
> > still accepts PSCI HVCs in order to support SMP.
> > 
> > Thanks,
> > Jean
> > 
> 
