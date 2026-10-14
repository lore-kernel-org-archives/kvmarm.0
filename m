Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89DC5013AA;
	Wed, 14 Oct 2026 11:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976014; cv=none; b=EXV+kc8R1qylX5M/h0NF4G6nspZ/eQf9CXcuVNzm0CLNIV2abqtuLYwCZFi0n9kKAY+sWlYtYM9uqO/WmbSPxYnYbEAWP+RsKA3Gi73IieFba7RugcER+/GijNr6S8uKU+M1/bYiHaRrsY7/eqFgzBEAWa/WQjEQQMDmXgmnCF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976014; c=relaxed/simple;
	bh=zC1XLkCQEv0N2Jl2G0ILQ1AIWPxGAbiPdn+VZpkfXd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hm7a+92YiiJwHKhd0WNqzWW5H838s8s1gaK1v77tN9jj+7RBz71x5AcyoZDIyxRX/kY6uPXC8ZS4S3rXD1NcVEi1Bz8yWm2Ueca3fQmeP6GQKA1h0MDXOaPAhok0wrPcG38FlvWGJ1nmCQAThDRHFgjo/UMc1d/6QYD2tMcmhy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USk4I7LL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USk4I7LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B021F000FF;
	Wed, 14 Oct 2026 11:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791976010;
	bh=nqJITi1yynepa6R55uVgDB61+hhpepsYvwwFTVYeqSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=USk4I7LLhlBwYdN9f9H3UUrJPdb1inVFuwSGLjdRPCgeKK5ZIozwxQYiTnJS/Ks5V
	 HXeUupUPU3EIajws+r5Vj68Zcrw5/uy6Nuawtfx+cedPT1Oe56aogCeOuefkC5kRt9
	 VHS/d0M8dtXeTSfKXN6w4txqS//+cFxvI4B3U+4HEf8HGCYZl4AjWKVXdndHyQ4gvp
	 d5ZW/jGD3Oamg11QvZYIKCClV7OrMYI1KuSRivCePkORHvnbyYhIgXtAgIqDpTyGmb
	 BXU3HXTDwjjHwhRYcfb1ht5IDstiazc9Hf6brqQx2ieaQqVSS6qnslAENxFqHqwx+g
	 mESo37TQ6NQSQ==
Date: Wed, 14 Oct 2026 12:06:43 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, kvmarm@lists.linux.dev,
	maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v22 02/10] firmware: arm_rmm: Check for RMI support at
 init
Message-ID: <20261014-dark-adaptable-echidna-ef9e51@sudeepholla>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-3-suzuki.poulose@arm.com>
 <2586e689-c27d-4e4c-8c69-03e24259cb96@redhat.com>
 <8be050e3-8af1-4f04-902f-9bc01b209dd0@arm.com>
 <3fbd4739-a4eb-4428-95ae-ead22e7cf9f2@redhat.com>
 <799fb810-c33e-4d0e-9a70-7092c0a681ff@arm.com>
 <0ceda99f-0352-474b-a30a-c5e79b817c2d@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ceda99f-0352-474b-a30a-c5e79b817c2d@redhat.com>

On Wed, Oct 14, 2026 at 08:58:00PM +1000, Gavin Shan wrote:
> On 10/14/26 7:19 PM, Suzuki K Poulose wrote:
> > On 14/10/2026 08:26, Gavin Shan wrote:
> > > On 10/13/26 7:58 PM, Suzuki K Poulose wrote:
> > > > On 13/10/2026 04:53, Gavin Shan wrote:
> > > > > Hi Suzuki,
> > > > > 
> > > > > 
> > > > > I think we need to ensure SMCCC version is v1.2 or a newer one here? arm_smccc_1_2_smc()
> > > > > is immediately called by rmi_smccc_invoke() after this check.
> > > > > 
> > > > >      if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC ||
> > > > >              arm_smccc_get_version() < ARM_SMCCC_VERSION_1_2)
> > > > 
> > > > We could. But I am wondering if that adds any value ? If the RMM
> > > > exists and responds to the RMI_ABI_VERSION, it must be so on a
> > > > platform with v1.2 or greater ? The extra check doesn't hurt.
> > > > 
> > > 
> > > It's required as documented in section "B1.1 overview" of RMM-spec-v2.0- bet3.
> > > In the same section, there are more requirements regarding the SMCCC version
> > > when SVE/SME are supported. I don't see a practical problem if the check is
> > > missed since the combination of TF-A and TF-RMM are the only RMM-spec- v2.0-bet3
> > > implementation (as I knew) where the SMCCC version has been set to v1.5 in the
> > > 'master' branch.
> > 
> > Reading the RMM spec again, DFNMZ lists how one can detect if the RMM
> > ABI is present. That specifies that the user checks for SMCCC
> > version >= 1.1, which we do by using arm_smccc_1_1_get_conduit().
> > 
> > Then checking the R{M,S}I_VERSION call is sufficient. So, I think
> > we are good here. Do you agree ?
> > 
> 

> arm_smccc_1_1_get_conduit() ensures SMCCC version >= v1.1, but we need
> SMCCC version >= v1.2. We will have problem if the firmware only supports
> SMCCC v1.1 and R{M,S}I_VERSION is coincidentally supported. In this
> rare (even impossible) case, it's not sufficient to check R{M,S}I_VERSION
> as I understand.
>

Indeed we need SMCCC v1.2+ as I can see the support for the RSI command
RSI_ATTESTATION_TOKEN_INIT which takes more than 8 registers as input
which is not possible with SMCCC v1.1 or below. Unless you have specific
check before those commands, it is better to have the check in the driver
init/probe phase.

> As far as TF-A+TF-RMM is concerned, I agree there is no issue. However,
> the extra check doesn't hurt and make the code following the spec a bit
> more strictly? :-)
> 

I tend to agree.

-- 
Regards,
Sudeep
