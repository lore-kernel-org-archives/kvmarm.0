Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E513C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 10:30:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB2734B28E;
	Mon,  4 Apr 2022 06:30:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id akjxrded4V+7; Mon,  4 Apr 2022 06:30:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BB0C4B215;
	Mon,  4 Apr 2022 06:30:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E531B4B1D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 06:30:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1GrOWWhjbPb3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 06:30:16 -0400 (EDT)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05B554B1C7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 06:30:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1649068216; x=1680604216;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=3RN1otC0NPrOipqgJl3sDhiojlobhjW+sltWEzivqII=;
 b=ZCghv2VymrfsknJZUTw9nrBf0e1jy7E5BBgVTAkXA6ahA3ykSuMIwMSP
 0lse2xmDaHb6Qt9f02ymxXDBHh/hJaIs8EyyV8dEVvrKo90OqY8DLgYWv
 LoDtkLw9zHe2bWeKGMM7xZFfjU8zQqtiU13DoN0xNghRFgBaTAEVcV02R
 T3qDbp7iRh1idvg+msiDiX8uSHwyV9eEcE3/81SraaA51maBBeV06X4Jo
 ZAWz1LRW7NrN3PmCSZNwKeLt/7vX4AOUEO7pWo0F1vCa/ySXFYNmAx5Eq
 1O8m4G/li89rBs5JRVTu5UIt5fIVM/wFjRgKRu/rB2RGJTFbXOmyAvmDZ Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="346923124"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; d="scan'208";a="346923124"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 04 Apr 2022 03:30:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; d="scan'208";a="607993640"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
 by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2022 03:30:11 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1nbJyM-0001y9-Jc;
 Mon, 04 Apr 2022 10:30:10 +0000
Date: Mon, 4 Apr 2022 18:29:28 +0800
From: kernel test robot <lkp@intel.com>
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v6 10/18] KVM: arm64: Support SDEI_PE_{MASK, UNMASK}
 hypercall
Message-ID: <202204041802.MNEvTtnJ-lkp@intel.com>
References: <20220403153911.12332-11-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220403153911.12332-11-gshan@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kbuild-all@lists.01.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 eauger@redhat.com, shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
 pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
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

Hi Gavin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.18-rc1 next-20220404]
[cannot apply to kvmarm/next kvm/master linux/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Gavin-Shan/Support-SDEI-Virtualization/20220403-234350
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git be2d3ecedd9911fbfd7e55cc9ceac5f8b79ae4cf
config: arm64-randconfig-c004-20220404 (https://download.01.org/0day-ci/archive/20220404/202204041802.MNEvTtnJ-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


cocci warnings: (new ones prefixed by >>)
>> arch/arm64/kvm/sdei.c:346:15-18: Unneeded variable: "ret". Return "SDEI_SUCCESS" on line 352

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
