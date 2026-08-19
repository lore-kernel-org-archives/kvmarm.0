Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209243B42E3
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787146888; cv=none; b=KoeFNgBbhfEX5xxc0lUAhDMFR5wZ0v9yIkLGa2TWovDRJMtgG2FpP5RslGOkaZYhTp3HfvY4hpDHyMahKjnVG+jtmeSz/q3z0ImyyJ9lbrT3hOdzgrVGmDKcFhS/+ZDzMooQTigmYNqHC9WZou1Unuv7VMWybNupmhycB92GqPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787146888; c=relaxed/simple;
	bh=5zZhTKxCzKM4mOTcYyTygUsinMLtPISXJYiMB3dpemQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=diOTWiint+oxkYiMSH0UEFFEzmhGvtOAbIa+ubXRTzNemqzLcHQD4Z8WNSRXos0kx/17g51g0E6l+O4r3Qf3cyYTJHrBr90D9IFGzL1Z7eDMTEU85Xrgt3dWnEp+M4GEkUN16OaevSVOh02UEB149qo1NfDK54qhJ77d3KeMacU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pm1ISSmU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pm1ISSmU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A702814BF;
	Wed, 19 Aug 2026 06:41:22 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67AB33F763;
	Wed, 19 Aug 2026 06:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787146886; bh=5zZhTKxCzKM4mOTcYyTygUsinMLtPISXJYiMB3dpemQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pm1ISSmUxwi6hQfB/vEfIpFGQITFK4bY2I5SUuTQlrnb/Mel5xpsYmWxDrYT67diI
	 IFg3h56TnXcrXw7IB5PrUI1pntS0CNdmpyGB9NkPAvB15n4H4CohGyldFleAyz9OhJ
	 B85n3+AOP/8vRpt74YuK/EqoLpjcd3yoFBJVykno=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 01/14] arm64/gcs: Ensure FGTs for EL1 GCS instructions are disabled
Date: Wed, 19 Aug 2026 14:41:13 +0100
Message-ID: <aoWyeTx8lYGfiwYc@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812-arm64-gcs-v19-1-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org> <20260812-arm64-gcs-v19-1-9105afd828ac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Mark, 

I will try my best to review this series, but I am new to this subject and 
have just finished reading the Arm ARM chapter about this, so please be 
patient with questions that may sound dumb or things that I got wrong.

On Wed, Aug 12, 2026 at 08:12:00PM +0100, Mark Brown wrote:
> The initial EL2 setup for GCS did not include disabling of EL1 usage of
> GCS instructions, also disable these traps.
> 
> Fixes: ff5181d8a2a8 ("arm64/gcs: Provide basic EL2 setup to allow GCS usage at EL0 and EL1")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/el2_setup.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index aa8ec9df8024..d308c6e6757d 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -393,6 +393,11 @@
>  	orr	x0, x0, #HFGRTR_EL2_nGCS_EL1_MASK
>  	orr	x0, x0, #HFGRTR_EL2_nGCS_EL0_MASK
>  
> +	/* Disable traps of GCS instructions at EL1 */
> +	orr	x2, x2, #HFGITR_EL2_nGCSEPP_MASK
> +	orr	x2, x2, #HFGITR_EL2_nGCSSTR_EL1_MASK
> +	orr	x2, x2, #HFGITR_EL2_nGCSPUSHM_EL1_MASK
> +

In the Arm ARM M.c, D24.2.70, we have that by setting the above bits we 
will _not_ trap the following instructions to EL2:
- GCSPUSHX, 
- GCSPOPCX, 
- GCSPUSHM, 
- GCSSTR, 
- GCSSTTR (when PSTATE.UAO=1 or HCSR_EL2.{NV,NV1} = {1,1}.)

Which I understand to be the way of us saying that EL2 will not interfere 
on nor manage those instructions that let software change the entries of 
GCS. Is that correct?

As for the asm routine, x2 at this point have nBRBIALL and nBRBINJ already 
set, and will be loaded to SYS_HFGITR_EL2 in the next block of 
instructions.

Did I get it right? Is there any missing detail here?

Thanks!
Leo


