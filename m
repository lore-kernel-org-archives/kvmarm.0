Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A37532AADB;
	Fri, 31 Oct 2025 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901031; cv=none; b=vDSlxtSUl0QlgTVYOnwTf65Ilo61jWHqry+RD3JGa3Z62fCly3JVdH0tZGiLccxWN3m/oQnWYXt1jeMmegS4nrore3a1bnnAE0Yazp1Tu8WuadUNINUaHUohzzf918hM0bCPLhg8tA7UPPoFBaAdfpuOmuevhu2ap4WC1ey/DBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901031; c=relaxed/simple;
	bh=4KtmtUmeRKY0mhGFlHsvUKmdbP8tr/tefUK44+GBirI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iI4FHiikgKWa3jlCF0SX5d9Y3gfwRBiSWP3YfHOfMMmTRj1epL0GKEDL9/YT1fVe7Pltz3wkzj4Ra3zS7/DS8FuREe7wVHdnIDG4JOy60Xg0LZHpIxPNnl85EaHGxblqBxNmIgDzJPBQXBA2Vzs+NguAzPiGpJk+cygalCQcNzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kmsoxXtL; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kmsoxXtL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901030; x=1793437030;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4KtmtUmeRKY0mhGFlHsvUKmdbP8tr/tefUK44+GBirI=;
  b=kmsoxXtLm5seRBblXpIeX24B9+tvv74UDZfIwB9mubmQEe2CFPBIFEDg
   2XPT5QBUQP26OX74Qm92KzYJ5BysNX2CY5A++24rJhjNh5LcYxWRzrYOM
   AcdNgUE8k9hftAcbb8xvRBzaHKzqyjAXHK9rnX5eO6c8fduw3DaCrolWX
   yyHZwrxbB7EP7UkExeo6m9x819yHcHlzk0CdsrAKYejHYV4l9Efj6RJpl
   XZwPPqylrXdu4lfVtBJ/ni31u5W6rb4jYDpj43A1ubZOU3NNsX3Ctc+vT
   WYuGJLgWYPShdAs2bZ6JseH2wN+WpZ2Ut/nokOv85XqyzkCtor+8Dy7TF
   w==;
X-CSE-ConnectionGUID: 6r9MLoarSPWp1DqvcqYfsQ==
X-CSE-MsgGUID: /oP5i/KvSbuqJ1TFY4PfNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="64088659"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="64088659"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:57:09 -0700
X-CSE-ConnectionGUID: sPC6mEPlSqSwx3TQdrZz6Q==
X-CSE-MsgGUID: BsJwtL+UTb27i21msflWIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186118722"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:56:55 -0700
Message-ID: <88d479a0-e849-49d6-86e7-8cd00daccee0@linux.intel.com>
Date: Fri, 31 Oct 2025 16:56:52 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/28] KVM: TDX: Fold tdx_sept_zap_private_spte() into
 tdx_sept_remove_private_spte()
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-18-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Do TDH_MEM_RANGE_BLOCK directly in tdx_sept_remove_private_spte() instead
> of using a one-off helper now that the nr_premapped tracking is gone.
>
> Opportunistically drop the WARN on hugepages, which was dead code (see the
> KVM_BUG_ON() in tdx_sept_remove_private_spte()).
>
> No functional change intended.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

