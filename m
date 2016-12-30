From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Fri, 30 Dec 2016 10:44:23 +0800
Message-ID: <201612301000.Aevrg8rZ%fengguang.wu@intel.com>
References: <20161229224335.13531-2-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6C8740499
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 21:43:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mU6DBr7vhUti for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2016 21:43:31 -0500 (EST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CB8940194
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 21:43:30 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161229224335.13531-2-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kbuild-all@01.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Shanker,

[auto build test ERROR on next-20161224]
[also build test ERROR on v4.10-rc1]
[cannot apply to arm64/for-next/core v4.9-rc8 v4.9-rc7 v4.9-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Christopher-Covington/arm64-Define-Falkor-v1-CPU/20161230-081412
config: arm64-allnoconfig (attached as .config)
compiler: aarch64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=arm64 

All errors (new ones prefixed by >>):

   arch/arm64/mm/context.c: In function 'flush_context':
>> arch/arm64/mm/context.c:93:13: error: 'CONFIG_QCOM_FALKOR_E1003_RESERVED_ASID' undeclared (first use in this function)
      __set_bit(CONFIG_QCOM_FALKOR_E1003_RESERVED_ASID, asid_map);
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/mm/context.c:93:13: note: each undeclared identifier is reported only once for each function it appears in
   arch/arm64/mm/context.c: In function 'asids_init':
   arch/arm64/mm/context.c:255:13: error: 'CONFIG_QCOM_FALKOR_E1003_RESERVED_ASID' undeclared (first use in this function)
      __set_bit(CONFIG_QCOM_FALKOR_E1003_RESERVED_ASID, asid_map);
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim +/CONFIG_QCOM_FALKOR_E1003_RESERVED_ASID +93 arch/arm64/mm/context.c

    87		/* Update the list of reserved ASIDs and the ASID bitmap. */
    88		bitmap_clear(asid_map, 0, NUM_USER_ASIDS);
    89	
    90		/* Reserve ASID for Falkor erratum 1003 */
    91		if (IS_ENABLED(CONFIG_QCOM_FALKOR_ERRATUM_1003) &&
    92		    cpus_have_cap(ARM64_WORKAROUND_QCOM_FALKOR_E1003))
  > 93			__set_bit(CONFIG_QCOM_FALKOR_E1003_RESERVED_ASID, asid_map);
    94	
    95		/*
    96		 * Ensure the generation bump is observed before we xchg the

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--rwEMma7ioTxnRzrJ
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
lUHq6PqtiVQsSPSZ/wGAlVRRa1kAAA==

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--rwEMma7ioTxnRzrJ--
