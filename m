Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C51629415
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696351886; x=1727887886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/AiN8Lf0vu90G463DTMPZKWFCMbDc4/B5lvdM2PPWQQ=;
  b=Di8W8H5uwax46ozzdzSiEVf3JrZogB78e3ZDQ6OlUM04u260yfncT+8J
   PIa9TTrv7D9v7I7GS9zGPbPUKdf22W6PuAHMHwZNMsqtASo7kP1GgTx8A
   r4oZ9mABOZwL4U/SosYpMdCEEDQVsiQY04VThwfXfAkmjlM/gvP6FxO8y
   6ORQb8lTVFsSHsRnt/zeBUbb4WGnUT5aIgXFtsLQzYIpScPv18vUoKve1
   kHcoimYyhpgznKpC8ma3L5D5e9hA5CaNJpIBo7vXkL/hB1cixSaMSV9Zh
   rPgye8/FjARPWZJIcCIGLV4s6LQB3YaOXPv/vCPdICsmPkew2aXLV164U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="413835572"
X-IronPort-AV: E=Sophos;i="6.03,197,1694761200"; 
   d="scan'208";a="413835572"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 09:51:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="816754780"
X-IronPort-AV: E=Sophos;i="6.03,197,1694761200"; 
   d="scan'208";a="816754780"
Received: from ddiaz-mobl4.amr.corp.intel.com (HELO [10.209.57.36]) ([10.209.57.36])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 09:51:24 -0700
Message-ID: <309e8637-c317-3bd1-fbe3-e15a4138c127@intel.com>
Date: Tue, 3 Oct 2023 09:51:24 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 09/20] arm64: define VM_PKEY_BIT* for arm64
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: nd@arm.com, akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
 catalin.marinas@arm.com, dave.hansen@linux.intel.com, maz@kernel.org,
 oliver.upton@linux.dev, shuah@kernel.org, will@kernel.org,
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-10-joey.gouly@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230927140123.5283-10-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/27/23 07:01, Joey Gouly wrote:
> -#ifdef CONFIG_ARCH_HAS_PKEYS
> +#if defined(CONFIG_ARCH_HAS_PKEYS) && !defined(CONFIG_ARM64)
>  # define VM_PKEY_SHIFT	VM_HIGH_ARCH_BIT_0
>  # define VM_PKEY_BIT0	VM_HIGH_ARCH_0	/* A protection key is a 4-bit value */
>  # define VM_PKEY_BIT1	VM_HIGH_ARCH_1	/* on x86 and 5-bit value on ppc64   */
> @@ -341,6 +341,15 @@ extern unsigned int kobjsize(const void *objp);
>  #endif
>  #endif /* CONFIG_ARCH_HAS_PKEYS */
>  
> +#if defined(CONFIG_ARM64)
> +# define VM_PKEY_SHIFT	VM_HIGH_ARCH_BIT_2
> +# define VM_PKEY_BIT0	VM_HIGH_ARCH_2	/* A protection key is a 3-bit value on arm64 */
> +# define VM_PKEY_BIT1	VM_HIGH_ARCH_3
> +# define VM_PKEY_BIT2	VM_HIGH_ARCH_4
> +# define VM_PKEY_BIT3	0
> +# define VM_PKEY_BIT4	0
> +#endif

This might be a bit cleaner to just defer out to a per-arch header.  It
made sense for ppc and x86 to share their copy in here, but now that a
third one is around we should probably move this to actual arch/ code.
