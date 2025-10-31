Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE500322C70;
	Fri, 31 Oct 2025 09:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761902263; cv=none; b=JANGNM2uWlyVzlQ9YboHzj1dt/1o6Czxcwsl7DnmuUFTlBMhUVuUZ6/wLiMGT1LavHQWzFt6ELW7Gznv86AvFCEflNLxXZhxwZK2FKhCGi3oYX5zd1B/AW8vKw/7PI3VSI6OoJYGGo8rHTzPYzmSJB/lCngbdk7iDASTm3UIllw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761902263; c=relaxed/simple;
	bh=6+fdM28QuB9T1HFnYCRzCUXVpG1QU1xA4LJIWTCndpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9eQQ1ue4PGWeMK1iAFjRCTiEmw48fh1YDHnYHXaMaqNAoP8CvD5cpcNayDhXxW+vEJRjwIHSGyiofY0NVN11C3Jr6GQmpPguSs9YiRp4BTyq96zCOuSPNxnhoJDYG2nRBtFAWk6zS4RuVC6nfBarFzCCrqSAcazHwdnB8XA97k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bEcwznLh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bEcwznLh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761902262; x=1793438262;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6+fdM28QuB9T1HFnYCRzCUXVpG1QU1xA4LJIWTCndpE=;
  b=bEcwznLhMIcFn+sVDVSO8r6aCscJyCi3kE8oCvdG+aeLEvWmEcnomWAA
   4GbOLdqeyZ2kvC6VqL9sm7ZKHqWsbyyoh2eVNgZc6wWTV/FSsgrbZPcNf
   kgndqtoCanTlczctUNw4ZPhiT3Rnmfzx0symwMPSGZ7qvtSIRIIG9bata
   yn45f3ZASzpRl/OjiOXyOIJ+lmnRQ5TqeFNjPKGQu4coT1ZvzkkCkINzS
   azElLHT7dLqpBwKGECaCTJU0iJkri4oBVdHZutMaozpWJDqATOvPo3gMP
   aLpLwbv1DPSdc30/77AZQHwHYrpRABSPyYEy5SO/uaeX/KrJIKFXZmKO4
   w==;
X-CSE-ConnectionGUID: nfXL9dDJT4OJap4PzpRGAQ==
X-CSE-MsgGUID: YODUUC95RmC8fpQ2z3Z/FA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="89525076"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="89525076"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:17:41 -0700
X-CSE-ConnectionGUID: xN3TnblrQqeOxewqaIMiwg==
X-CSE-MsgGUID: 7VuncW0PQxeTB4CUZL105Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186126269"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:17:33 -0700
Message-ID: <94e3e701-b60d-419b-b3c1-2b41796ab5c3@linux.intel.com>
Date: Fri, 31 Oct 2025 17:17:29 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 24/28] KVM: TDX: Use guard() to acquire kvm->lock in
 tdx_vm_ioctl()
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
 <20251030200951.3402865-25-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-25-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Use guard() in tdx_vm_ioctl() to tidy up the code a small amount, but more
> importantly to minimize the diff of a future change, which will use
> guard-like semantics to acquire and release multiple locks.
>
> No functional change intended.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

