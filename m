Return-Path: <SRS0=H2W4=6I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC650C55186
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 08:41:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A443520728
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 08:41:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1QqFfDfH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A443520728
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA7D4B296;
	Fri, 24 Apr 2020 04:41:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5YHlnle0wK19; Fri, 24 Apr 2020 04:41:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BDD24B25C;
	Fri, 24 Apr 2020 04:41:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55F7A4B1BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 04:41:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GgsiK8q0On3K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2020 04:41:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 611E34B187
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 04:41:20 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3F1C420728;
 Fri, 24 Apr 2020 08:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587717679;
 bh=PV534O9kwIgM8gDEbfwGPkZ8V9ac73fo3ahFLX6BjaI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=1QqFfDfHUZgwGjrY43McTUlwILsc/6ziND4I36dhOBF4rEx1WpkDu9M5aGRqxq1y5
 +pAxF9b8HtcN4f8UZie1asNf2n35KNPqVEcw+JPzUGBpIj5e/eOvd3Nx/tNG3l3gM8
 hS1S0sTZf8mElx7IMuum09loH9rM5EBx9wNsKbHc=
Date: Fri, 24 Apr 2020 09:41:15 +0100
From: Will Deacon <will@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v4 4/5] memslot: Add support for READONLY mappings
Message-ID: <20200424084114.GC20801@willie-the-truck>
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <20200423173844.24220-5-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200423173844.24220-5-andre.przywara@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Raphael Gault <raphael.gault@arm.com>, Sami Mujawar <sami.mujawar@arm.com>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Apr 23, 2020 at 06:38:43PM +0100, Andre Przywara wrote:
> A KVM memslot has a flags field, which allows to mark a region as
> read-only.
> Add another memory type bit to allow kvmtool-internal users to map a
> write-protected region. Write access would trap and can be handled by
> the MMIO emulation, which should register on the same guest address
> region.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/kvm.h | 12 ++++++++----
>  kvm.c             |  5 +++++
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 9428f57a..53373b08 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -40,10 +40,12 @@ enum kvm_mem_type {
>  	KVM_MEM_TYPE_RAM	= 1 << 0,
>  	KVM_MEM_TYPE_DEVICE	= 1 << 1,
>  	KVM_MEM_TYPE_RESERVED	= 1 << 2,
> +	KVM_MEM_TYPE_READONLY	= 1 << 3,
>  
>  	KVM_MEM_TYPE_ALL	= KVM_MEM_TYPE_RAM
>  				| KVM_MEM_TYPE_DEVICE
>  				| KVM_MEM_TYPE_RESERVED
> +				| KVM_MEM_TYPE_READONLY
>  };
>  
>  struct kvm_ext {
> @@ -158,17 +160,19 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
>  bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
>  				 const char *kernel_cmdline);
>  
> +#define add_read_only(type, str)					\

nit: this is a bit broad to throw in a header file. How about
__kvm_mem_add_read_only()  instead?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
