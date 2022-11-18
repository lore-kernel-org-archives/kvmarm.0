Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C61C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 16:49:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91A534B9E2;
	Fri, 18 Nov 2022 11:49:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rKjQHFRz7-W0; Fri, 18 Nov 2022 11:49:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46ADE4B9E3;
	Fri, 18 Nov 2022 11:49:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C834B9DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 11:49:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WNuGYbTA0BJ2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 11:49:54 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1996C4B9D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 11:49:54 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4994F62658;
 Fri, 18 Nov 2022 16:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE7DC433D6;
 Fri, 18 Nov 2022 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668790192;
 bh=Ezeq8ffMYvaPt9FpoGuX5EQSh2HNXruXkEIhBtNrqXo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=t+JTQsE5gBlbQKNkVdC+DxA8XuWAPw+UeaHxdk4s7mPJ549BmuWk3MM6R4F6c7n6C
 EsCL6Hk9H1J8XQPoNjTdfH2WJ8E6eUXq6otr2IhTOtYkxxdm3zXcv0un0lLCl5sc+t
 3VP++ldEfKNntD/Tt+XxhZ/oVmWxCS39+2V0zwu4sPIrvGXB/u4JjkclpYadaIR7LR
 m42PXa1FGhJvPcWmctVEpKKAzJetqlDkoRMDxgIJ/ipTmOv6diUYQI7rA0BGhoKyy+
 QDDPH2K1Iv6AFjuh4lxI7nQdxnJZBu0jk91emROjy0tryHhV5qU+56VwXbPiW+8s82
 OEFUywC54fQwA==
Date: Fri, 18 Nov 2022 16:49:45 +0000
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 7/8] perf: Add perf_event_attr::config3
Message-ID: <20221118164943.GA4872@willie-the-truck>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Namhyung Kim <namhyung@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, James Clark <james.clark@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Nov 04, 2022 at 10:55:07AM -0500, Rob Herring wrote:
> Arm SPEv1.2 adds another 64-bits of event filtering control. As the
> existing perf_event_attr::configN fields are all used up for SPE PMU, an
> additional field is needed. Add a new 'config3' field.
> 
> Tested-by: James Clark <james.clark@arm.com>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v3:
>  - No change
> v2:
>  - Drop tools/ side update
> ---
>  include/uapi/linux/perf_event.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 85be78e0e7f6..b2b1d7b54097 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -374,6 +374,7 @@ enum perf_event_read_format {
>  #define PERF_ATTR_SIZE_VER5	112	/* add: aux_watermark */
>  #define PERF_ATTR_SIZE_VER6	120	/* add: aux_sample_size */
>  #define PERF_ATTR_SIZE_VER7	128	/* add: sig_data */
> +#define PERF_ATTR_SIZE_VER8	136	/* add: config3 */
>  
>  /*
>   * Hardware event_id to monitor via a performance monitoring event:
> @@ -515,6 +516,8 @@ struct perf_event_attr {
>  	 * truncated accordingly on 32 bit architectures.
>  	 */
>  	__u64	sig_data;
> +
> +	__u64	config3; /* extension of config2 */

I need an ack from the perf core maintainers before I can take this.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
