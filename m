Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883C130BF79;
	Fri, 31 Oct 2025 09:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901878; cv=none; b=U3foQ+C8Plcbo8ovLIWatoSPOQWyA1ZVzrDtcb0eBd47Fo22X2SPG3PkESvkyCg4nFeL45IZV70PT7mU774GMyUVGF19WDrbzJNz42r0qyupumq5H2WTiwgpE5SumnOjpmTABiwp4oe3NpD5wq87Nc92ZAqfOlZW1AnOUFtsl1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901878; c=relaxed/simple;
	bh=nVFcr7cSAivJ3kX3Ong+t5W82ll2lBVB0+D6Fy+f66w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JkRMc2CN2l56U97rWh4DJ6uVBvkAnUvS9ht9eWlHCRL5g4B8ueANduS4cmRj3X/4JkARQB7NFp1usddejCJn51aK7mFMiwi8n3ORZL5tUCuJsVgfWQAswIPSGysRS3ziWjy3GNs3uRP79A/g9wu51VXxk72m6AWHrsM2UWFwVuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HQCZO9vT; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HQCZO9vT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901877; x=1793437877;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nVFcr7cSAivJ3kX3Ong+t5W82ll2lBVB0+D6Fy+f66w=;
  b=HQCZO9vTEpjJxjl/WaTCvT+awRwcTymmY5VKXIyecuwkdXGSQ4CdTnUI
   I+SrED/yK0H0+LUQlpaR8xRryORZOVL1URSehS1vyIaEvzTNXIcsTgOaH
   tdeT6vlFUshLs8u11njnrWwIo6ImhQlkoUHf7wDQ7H2h3/oCBBwIMMSdV
   ajxLSEMH9BbPzsF+p5NWMQ1TFqL3cp0KcQswEkWcN50GI+PFF8wH1sBsT
   HbD5HCUpsLuHLF3Cia/l8G5NOIlTYr9Cxnu2hexEzm33E+kjxoTct31c1
   32154/Mipa40drH93kHLEL9tV4E5ELqv45Hl4q3z5INSOrK4ZKbJ9HvRI
   g==;
X-CSE-ConnectionGUID: +lAODDlVSm2vwxdk5BDIfg==
X-CSE-MsgGUID: OzpNfrKcTZKFEJ7uAHz9Cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="74350453"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="74350453"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:11:16 -0700
X-CSE-ConnectionGUID: mtRCVhiuRGSbh+b9MLYkrw==
X-CSE-MsgGUID: naB5mn6dRoCATJ8bJWh6cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186124007"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:11:08 -0700
Message-ID: <709166ed-2102-46f2-807b-3d8139a386f0@linux.intel.com>
Date: Fri, 31 Oct 2025 17:11:05 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 22/28] KVM: TDX: Add tdx_get_cmd() helper to get and
 validate sub-ioctl command
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
 <20251030200951.3402865-23-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-23-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Add a helper to copy a kvm_tdx_cmd structure from userspace and verify
> that must-be-zero fields are indeed zero.
>
> No functional change intended.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

