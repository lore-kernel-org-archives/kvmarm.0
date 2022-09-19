Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0568BC54EE9
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 01:27:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 478554B839;
	Sun, 18 Sep 2022 21:27:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x1L3FQ-N3Q7m; Sun, 18 Sep 2022 21:27:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0DA74B836;
	Sun, 18 Sep 2022 21:27:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 373654B7FA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Sep 2022 21:27:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kjod9dfassz for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Sep 2022 21:27:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDDB74B836
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Sep 2022 21:27:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663550874;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mTlHJkSe2zwoVsxiCcbcUXVRXRosTOKrm+znhbWqwWI=;
 b=jEltpuvKknpBGp2cG2u1cMyzrj1eg8rsEbnPgeJTzymA+xbTg4qpVQzwSDC8k1GqfwwpHV
 EVDA875PpEGOdw3uImdznLxY5NikTzuCor4FOAi2MfF1hecXUISC+AsfZe43vtfjPREsDJ
 zyzH/Ezs6zBMHF1v+FuEBZoqEpTAe+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-Iy3PoTvROFe09ARVEqroCA-1; Sun, 18 Sep 2022 21:27:51 -0400
X-MC-Unique: Iy3PoTvROFe09ARVEqroCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 568FE85A583;
 Mon, 19 Sep 2022 01:27:50 +0000 (UTC)
Received: from [10.64.54.126] (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A6E5A40C6EC2;
 Mon, 19 Sep 2022 01:27:42 +0000 (UTC)
Subject: Re: [PATCH v2 2/5] KVM: arm64: Enable ring-based dirty memory tracking
To: kernel test robot <lkp@intel.com>, kvmarm@lists.cs.columbia.edu
References: <20220916045135.154505-3-gshan@redhat.com>
 <202209180726.FLL69aKA-lkp@intel.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <fbf2bbe6-06d7-8e06-3f7f-04ca01d604c0@redhat.com>
Date: Mon, 19 Sep 2022 11:27:40 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <202209180726.FLL69aKA-lkp@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: maz@kernel.org, drjones@redhat.com, kbuild-all@lists.01.org,
 shan.gavin@gmail.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 catalin.marinas@arm.com, corbet@lwn.net, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, will@kernel.org, linux-kselftest@vger.kernel.org,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com, shuah@kernel.org,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 9/18/22 1:10 AM, kernel test robot wrote:
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on kvm/queue]
> [also build test WARNING on kvmarm/next linus/master v6.0-rc5 next-20220916]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Gavin-Shan/KVM-arm64-Enable-ring-based-dirty-memory-tracking/20220916-125417
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220918/202209180726.FLL69aKA-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/a1a4cd8f6a5e8927f800baff7d965870a1b7d7ba
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Gavin-Shan/KVM-arm64-Enable-ring-based-dirty-memory-tracking/20220916-125417
>          git checkout a1a4cd8f6a5e8927f800baff7d965870a1b7d7ba
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> arch/arm64/kvm/../../../virt/kvm/dirty_ring.c:14:12: warning: no previous prototype for 'kvm_cpu_dirty_log_size' [-Wmissing-prototypes]
>        14 | int __weak kvm_cpu_dirty_log_size(void)
>           |            ^~~~~~~~~~~~~~~~~~~~~~
> 
> 

[...]

Thanks for reporting the issue. The weak function needn't to be overrided by
ARM64. In v3, I will have a separate patch to fix the issue by moving its
declaration to kvm_dirty_ring.h.

Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
