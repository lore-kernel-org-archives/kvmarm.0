Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665CA30CF2
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 16:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696351611; x=1727887611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nN2KPp3CaN2kwskRxd/Tu+L9S923Q8/Pb0VWg57BRPA=;
  b=bIh/AdAAdw5LyT3G7gPgoZjrkkyquKAd7233EPjYAiNdjMNXWxwT60qu
   gGfnnqaaukivtn/X/cn3xx9rh+g3zTTBTAwchtRz9XENXoacV4d/jule0
   aUP37koViXIDDeoL0TXDV0k86cN7cE8VzAMsNW593mxYmWUViiL2WaHvT
   VDrCVBwGTDvYqfdmVHaHAGCC9ErrgUTKzMLHV/hSARPOrORaM1H+nW0cS
   dNeqZECDaC20a7ktrQGIW4Hmvyq1514JkGipX1grxKVHEuAzsrZrqQNYW
   zRwAZ8WwHpO5honn+5tVga5jGa3E1lxO2yhlRFsMY2+qNL4RNpwCiHY4D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="380198940"
X-IronPort-AV: E=Sophos;i="6.03,197,1694761200"; 
   d="scan'208";a="380198940"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 09:46:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="841423262"
X-IronPort-AV: E=Sophos;i="6.03,197,1694761200"; 
   d="scan'208";a="841423262"
Received: from ddiaz-mobl4.amr.corp.intel.com (HELO [10.209.57.36]) ([10.209.57.36])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 09:46:49 -0700
Message-ID: <36c9a903-eb48-f262-9d39-c58ff7fb8052@intel.com>
Date: Tue, 3 Oct 2023 09:46:49 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 19/20] selftests: mm: move fpregs printing
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: nd@arm.com, akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
 catalin.marinas@arm.com, dave.hansen@linux.intel.com, maz@kernel.org,
 oliver.upton@linux.dev, shuah@kernel.org, will@kernel.org,
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-20-joey.gouly@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230927140123.5283-20-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/27/23 07:01, Joey Gouly wrote:
> arm64's fpregs are not at a constant offset from sigcontext. Since this is
> not an important part of the test, don't print the fpregs pointer on arm64.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
