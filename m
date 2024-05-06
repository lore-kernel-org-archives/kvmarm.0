Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EBB143896
	for <kvmarm@lists.linux.dev>; Mon,  6 May 2024 12:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714997579; cv=none; b=YWIyQhNmtEHEmFYK3i710JA9rkycmlKeeax7YI8BZFlbLz3c+R8kjywFlBdkY8/iags1WrcQ5VojmuE3pN2WpSovjC/xtAppenqQZdazUF0R+465DhtbOepELRHYoYle1eMnF1iak23oTSxLeEP2eTNn8fzhq+vsQQDYSYt/ANc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714997579; c=relaxed/simple;
	bh=Iz5B8F7XltdwEMC2wpjkKK1FHOvCSMw2lG0kBy8i1wI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dU5bWkQ09g5mTiVWUVic6qdfgCQMqpF5Ji/86d1CRdpvzh+qaKVmWr3tXs8K0Sw9evekIEpS/yLP7LbdM+ZAWAChH+9oXhKZmAp66IYcvNyjvxzcDk3rMCuX0l8/UrROx3usyVBrCk76cfKJgt+YviH9hFg7jDGNeSy7MnecKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VY0Zh2Pknz1RBXH;
	Mon,  6 May 2024 20:09:32 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E3A41800C7;
	Mon,  6 May 2024 20:12:49 +0800 (CST)
Received: from [10.67.110.108] (10.67.110.108) by
 kwepemd200013.china.huawei.com (7.221.188.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 6 May 2024 20:12:46 +0800
Message-ID: <f301ebb0-adf2-33c9-d548-7738a010ce92@huawei.com>
Date: Mon, 6 May 2024 20:12:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v3 0/8] Rework the DAIF mask, unmask and track API
To: Mark Rutland <mark.rutland@arm.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <ardb@kernel.org>,
	<broonie@kernel.org>, <anshuman.khandual@arm.com>, <miguel.luis@oracle.com>,
	<joey.gouly@arm.com>, <ryan.roberts@arm.com>, <jeremy.linton@arm.com>,
	<ericchancf@google.com>, <kristina.martsenko@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<shijie@os.amperecomputing.com>, <akpm@linux-foundation.org>,
	<bhe@redhat.com>, <horms@kernel.org>, <mhiramat@kernel.org>,
	<rmk+kernel@armlinux.org.uk>, <shahuang@redhat.com>,
	<takakura@valinux.co.jp>, <dianders@chromium.org>, <swboyd@chromium.org>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <reijiw@google.com>,
	<akihiko.odaki@daynix.com>, <ruanjinjie@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
References: <20240415064758.3250209-1-liaochang1@huawei.com>
 <ZjUadl2Kbv-KyveZ@FVFF77S0Q05N>
From: "Liao, Chang" <liaochang1@huawei.com>
In-Reply-To: <ZjUadl2Kbv-KyveZ@FVFF77S0Q05N>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200013.china.huawei.com (7.221.188.133)



在 2024/5/4 1:10, Mark Rutland 写道:
> Hi,
> 
> On Mon, Apr 15, 2024 at 06:47:50AM +0000, Liao Chang wrote:
>> This patch series reworks the DAIF mask, unmask, and track API for the
>> upcoming FEAT_NMI extension added in Armv8.8.
>>
>> As platform and virtualization[1] supports for FEAT_NMI is emerging, and
>> Mark Brown's FEAT_NMI patch series[2] highlighted the need for clean up
>> the existing hacking style approach about DAIF management code before
>> adding NMI functionality, furthermore, we discover some subtle bugs
>> during 'perf' and 'ipi_backtrace' transition from PSEUDO_NMI to
>> FEAT_NMI, in summary, all of these emphasize the importance of rework.
>>
>> This series of reworking patches follows the suggestion from Mark
>> Rutland mentioned in Mark Brown's patchset. In summary, he think the
>> better way for DAIF manangement look likes as following:
>>
>> (a) Adding entry-specific helpers to manipulate abstract exception masks
>>     covering DAIF + PMR + ALLINT. Those need unmask-at-entry and
>>     mask-at-exit behaviour, and today only need to manage DAIF + PMR.
>>
>>     It should be possible to do this ahead of ALLINT / NMI support.
>>
>> (b) Adding new "logical exception mask" helpers that treat DAIF + PMR +
>>     ALLINT as separate elements. 
> 
> I've started looking at this in the series. There are some subtleties here, and
> I don't think the helpers in this series are quite right as-is. I will try to
> get back to you next week with a description of those; it'll take a short while
> to write that up correctly and clearly and I don't trust myself to rush that
> last thing on a Friday.
> 
> Thanks,
> Mark.

Hi，Mark

Thanks for your feedback.I apprecaite your interest in this patch series
and look forward to receiving additional comments from you and others in
the community.

I am pleased to inform you that the FEAT_NMI features has been successfully
merged into the upstream QEMU codebase at the "master" branch recently. This
allow for initial testing without requiring hardware support for FEAT_NMI.

To ensure minimal regressions introduced by this patch series, i have done
testing using perf top, hardlokup and ipi nmi for various configurations,
including (1) no NMI (2) use CONFIG_PSEUDO_NMI (3) use CONFIG_ARM64_NMI.

We encourage further discussion and feedback on the patch series. We are
particularly interested in hearing from developers who might have experience
with NMI handling or those using platforms with FEAT_NMI capabilities.

Thank you.

> 
>>
>> This patches cherry-pick a part of Mark Brown' FEAT_NMI series, in order
>> to pass compilation and basic testing, includes perf and ipi_backtrace.
>>
>> [1] https://lore.kernel.org/all/20240407081733.3231820-1-ruanjinjie@huawei.com/
>> [2] https://lore.kernel.org/linux-arm-kernel/Y4sH5qX5bK9xfEBp@lpieralisi/
>>
>> v3->v2:
>> 1. Squash two commits that address two minor issues into Mark Brown's
>>    origin patch for detecting FEAT_NMI.
>> 2. Add one patch resolves the kprobe reenter panic while testing
>>    FEAT_NMI on QEMU.
>>
>> v2->v1:
>> Add SoB tags following the origin author's SoBs.
>>
>> Liao Chang (5):
>>   arm64: daifflags: Add logical exception masks covering DAIF + PMR +
>>     ALLINT
>>   arm64: Unify exception masking at entry and exit of exception
>>   arm64: Deprecate old local_daif_{mask,save,restore}
>>   irqchip/gic-v3: Improve the maintainability of NMI masking in GIC
>>     driver
>>   arm64: kprobe: Keep NMI maskabled while kprobe is stepping xol
>>
>> Mark Brown (3):
>>   arm64/sysreg: Add definitions for immediate versions of MSR ALLINT
>>   arm64/cpufeature: Detect PE support for FEAT_NMI
>>   arm64/nmi: Add Kconfig for NMI
>>
>>  arch/arm64/Kconfig                   |  17 ++
>>  arch/arm64/include/asm/cpufeature.h  |   6 +
>>  arch/arm64/include/asm/daifflags.h   | 298 ++++++++++++++++++++++-----
>>  arch/arm64/include/asm/nmi.h         |  27 +++
>>  arch/arm64/include/asm/sysreg.h      |   2 +
>>  arch/arm64/include/uapi/asm/ptrace.h |   1 +
>>  arch/arm64/kernel/acpi.c             |  10 +-
>>  arch/arm64/kernel/cpufeature.c       |  58 +++++-
>>  arch/arm64/kernel/debug-monitors.c   |   7 +-
>>  arch/arm64/kernel/entry-common.c     |  96 +++++----
>>  arch/arm64/kernel/entry.S            |   2 -
>>  arch/arm64/kernel/hibernate.c        |   6 +-
>>  arch/arm64/kernel/irq.c              |   2 +-
>>  arch/arm64/kernel/machine_kexec.c    |   2 +-
>>  arch/arm64/kernel/probes/kprobes.c   |   4 +-
>>  arch/arm64/kernel/setup.c            |   2 +-
>>  arch/arm64/kernel/smp.c              |   6 +-
>>  arch/arm64/kernel/suspend.c          |   6 +-
>>  arch/arm64/kvm/hyp/vgic-v3-sr.c      |   6 +-
>>  arch/arm64/kvm/hyp/vhe/switch.c      |   4 +-
>>  arch/arm64/mm/mmu.c                  |   6 +-
>>  arch/arm64/tools/cpucaps             |   2 +
>>  drivers/irqchip/irq-gic-v3.c         |   6 +-
>>  23 files changed, 442 insertions(+), 134 deletions(-)
>>  create mode 100644 arch/arm64/include/asm/nmi.h
>>
>> -- 
>> 2.34.1
>>
>>
> 

-- 
BR
Liao, Chang
