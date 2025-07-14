Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E80A22F152
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533388; cv=none; b=TBtEwpE1VNH56dhdAt3iPo7bacdadw8xd4dZI5agUOI4mQcc7jwhNfQghZQ1En5mEEp6sRqnVXL6vOUA72djhQu1Sq9gL1yg5tPHLJVnfU6nOUQnnNxA3l6YG5dS73z72PSqnhd07xsoRoTlwCGryZv8aZNGs0WS2soFjZzVfw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533388; c=relaxed/simple;
	bh=mih07qOfUoD8s/i/7luX1+TCrpdWefgDf9Cxi7n/dxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CtXPr51CfMSffH5zq8s9y2Ll1SDPOVD9yOOidW6Cu+rfAzGs4h1TAX7PtLXlAOzJTkOK1iH/YmwdZ16+uSrZpo6jpwCi7Il/3uPOHH6igFY0Vvr/qwTWvHy6e8d3W4UHiGvmMcJMSMWMmjziRKQ6ug/SOKV4VwmcHzI0jRDmqSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pLGbGjVP; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pLGbGjVP"
Date: Tue, 15 Jul 2025 07:49:35 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752533383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DhtNZ/JtE06J68JlpKj4Qz5mfna8Ev77cq2FCJzJbDA=;
	b=pLGbGjVPwMzShT4hZLTlUsfwQBtVQZU3JxxzrWFNTOUAoeFswsmrcA8U9uiQJ9p500v82m
	xG50W5KzoG2V4ZCFyy0TtZuD+2Bau24F9p1yuk9VrZmh0fv2yXYY3Xzm9t2Q7nmtaSDiXy
	613C6kK74poB1oKrh7zS+x9XNIqlDeY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 09/11] KVM: arm64: selftests: get-reg-list: Simplify
 feature dependency
Message-ID: <aHWJf4JrcclSnJSo@vm4>
References: <20250714122634.3334816-1-maz@kernel.org>
 <20250714122634.3334816-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714122634.3334816-10-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 14, 2025 at 01:26:32PM +0100, Marc Zyngier wrote:
> Describing the dependencies between registers and features is on
> the masochistic side of things, with hard-coded values that would
> be better taken from the existing description.
> 
> Add a couple of helpers to that effect, and repaint the dependency
> array. More could be done to improve this test, but my interest is
> wearing  thin...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../selftests/kvm/arm64/get-reg-list.c        | 52 ++++++++-----------
>  1 file changed, 22 insertions(+), 30 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
> index d01798b6b3b47..a35b01d08cc63 100644
> --- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
> @@ -15,6 +15,12 @@
>  #include "test_util.h"
>  #include "processor.h"
>  
> +#define SYS_REG(r)	ARM64_SYS_REG(sys_reg_Op0(SYS_ ## r),	\
> +				      sys_reg_Op1(SYS_ ## r),	\
> +				      sys_reg_CRn(SYS_ ## r),	\
> +				      sys_reg_CRm(SYS_ ## r),	\
> +				      sys_reg_Op2(SYS_ ## r))
> +
>  struct feature_id_reg {
>  	__u64 reg;
>  	__u64 id_reg;
> @@ -22,37 +28,23 @@ struct feature_id_reg {
>  	__u64 feat_min;
>  };
>  
> -static struct feature_id_reg feat_id_regs[] = {
> -	{
> -		ARM64_SYS_REG(3, 0, 2, 0, 3),	/* TCR2_EL1 */
> -		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
> -		0,
> -		1
> -	},
> -	{
> -		ARM64_SYS_REG(3, 0, 10, 2, 2),	/* PIRE0_EL1 */
> -		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
> -		8,
> -		1
> -	},
> -	{
> -		ARM64_SYS_REG(3, 0, 10, 2, 3),	/* PIR_EL1 */
> -		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
> -		8,
> -		1
> -	},
> -	{
> -		ARM64_SYS_REG(3, 0, 10, 2, 4),	/* POR_EL1 */
> -		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
> -		16,
> -		1
> -	},
> -	{
> -		ARM64_SYS_REG(3, 3, 10, 2, 4),	/* POR_EL0 */
> -		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
> -		16,
> -		1
> +#define FEAT(id, f, v)					\
> +	.id_reg		= SYS_REG(id),			\
> +	.feat_shift	= id ## _ ## f ## _SHIFT,	\
> +	.feat_min	= id ## _ ## f ## _ ## v
> +
> +#define REG_FEAT(r, id, f, v)			\
> +	{					\
> +		.reg = SYS_REG(r),		\
> +		FEAT(id, f, v)			\
>  	}
> +
> +static struct feature_id_reg feat_id_regs[] = {
> +	REG_FEAT(TCR2_EL1,	ID_AA64MMFR3_EL1, TCRX, IMP),
> +	REG_FEAT(PIRE0_EL1,	ID_AA64MMFR3_EL1, S1PIE, IMP),
> +	REG_FEAT(PIR_EL1,	ID_AA64MMFR3_EL1, S1PIE, IMP),
> +	REG_FEAT(POR_EL1,	ID_AA64MMFR3_EL1, S1POE, IMP),
> +	REG_FEAT(POR_EL0,	ID_AA64MMFR3_EL1, S1POE, IMP),
>  };
>  
>  bool filter_reg(__u64 reg)

After applied this series against kvm-next as of today, I testes this selftest on RevC FVP model with kvm-arm.mode=nested. All PASSed.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>


