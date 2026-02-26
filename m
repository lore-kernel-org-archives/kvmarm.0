Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3683F23BD05
	for <kvmarm@lists.linux.dev>; Thu, 26 Feb 2026 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772091288; cv=none; b=PIlR0+UDQXZnpWEU6OlrdUkoSNTtXNqW1kF3bZ4IqkiDU4hDzjqZptwbPE5rlMGMl8EfDcIwbEwZMc7Lb81C8v2d7zaXquFZpJflIR1oCCqDqeNRs6cqnNE1FaqLyi8YWb0H035UZzw7RmPtveWierhod0AAO9wnySrHYwgCtA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772091288; c=relaxed/simple;
	bh=wnBP8d+RyNNhi2A9YH6hfDNqXv58LjqYtQbo9porOuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Yitws9h0P9kQhN9HlBOzP5Khj78nKKO/44VagyfONTa5vXcy2X0H7GK4I3ViJRfX7frSX1Md9i1xF7r+xWN9JR+juka3QOqXpBuyNwJZlJyZTKZTI9o0JJqcxJoa+jbF8sgc0Og0bp/PIF+NkkyZCfQB1fleG5MUYuqOkY9X0ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=jSJ/Nudz; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="jSJ/Nudz"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HTgQ3pwYhImVxsWKPbJY3hkexd9HV5HCGzaCSReOgFw=;
	b=jSJ/Nudzjtbu/jWdnnhs2ou1dXmXsuZbCHjjQbbzhUXsi1aMh7+VKYsWb9wqf64rzIxFrIuAi
	R69coEWNz/484kjVXwo/qcxOcn59/6D0SwKQMJOW523dRpPG874qSLEsw4rr/bSJ5M0nhUyllru
	skkzDZc29Df2W1Bvr6gUMSA=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fM34h4z20zpStS;
	Thu, 26 Feb 2026 15:29:40 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 7FE7320168;
	Thu, 26 Feb 2026 15:34:29 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 26 Feb 2026 15:34:27 +0800
Message-ID: <dda7bdb9-f768-5012-62ca-b181a65cea27@huawei.com>
Date: Thu, 26 Feb 2026 15:34:26 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<jonathan.cameron@huawei.com>, <kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-doc@vger.kernel.org>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260224175720.2663924-1-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Hi Ben,

On 2026/2/25 1:56, Ben Horgan wrote:
> The main change in this version of the mpam missing pieces series is to
> update the cdp emulation to match the resctrl interface. L2 and L3
> resources can now enable cdp separately. Cdp can't be hidden correctly for
> memory bandwidth allocation, as max per partid can't be emulated with more
> partids, and so we hide this completely when cdp is enabled. There is a little
> restructuring and a few smaller changes.
> 
> Changelogs in patches
> 
> It would be great to get this series merged this cycle. For that we'll need
> more testing and reviewing. Thanks!
> 
>>From James' cover letter:
> 
> This is the missing piece to make MPAM usable resctrl in user-space. This has
> shed its debugfs code and the read/write 'event configuration' for the monitors
> to make the series smaller.
> 
> This adds the arch code and KVM support first. I anticipate the whole thing
> going via arm64, but if goes via tip instead, the an immutable branch with those
> patches should be easy to do.
> 
> Generally the resctrl glue code works by picking what MPAM features it can expose
> from the MPAM drive, then configuring the structs that back the resctrl helpers.
> If your platform is sufficiently Xeon shaped, you should be able to get L2/L3 CPOR
> bitmaps exposed via resctrl. CSU counters work if they are on/after the L3. MBWU
> counters are considerably more hairy, and depend on hueristics around the topology,
> and a bunch of stuff trying to emulate ABMC.
> If it didn't pick what you wanted it to, please share the debug messages produced
> when enabling dynamic debug and booting with:
> | dyndbg="file mpam_resctrl.c +pl"
> 
> I've not found a platform that can test all the behaviours around the monitors,
> so this is where I'd expect the most bugs.
> 
> The MPAM spec that describes all the system and MMIO registers can be found here:
> https://developer.arm.com/documentation/ddi0598/db/?lang=en
> (Ignored the 'RETIRED' warning - that is just arm moving the documentation around.
>   This document has the best overview)
> 

I have completed retesting based on glue v5. The latest boot logs are 
provided below:

# dmesg | grep -i mpam

[    0.000000] ACPI: MPAM 0x000000007FF34018 003024 (v01 HISI   HIP12 
00000000 HISI 20151124)
[    0.000000] Kernel command line: 
BOOT_IMAGE=/vmlinuz-7.0.0-rc1-g4288ec146462 
root=UUID=e0c69d2c-35e2-4ed0-9b5b-338fe4e689e8 ro cgroup_disable=files 
apparmor=0 crashkernel=1024M,high smmu.bypassdev=0x1000:0x17 
smmu.bypassdev=0x1000:0x15 arm64.nopauth console=ttyAMA0,115200 
net.ifnames=0 
modprobe.blacklist=hibmc_drm,ipmi_ssif,ipmi_devintf,ipmi_si selinux=0 
arm64.mpam nokaslr "dyndbg=file mpam_resctrl.c +p"
[    0.000000] Unknown kernel command line parameters "apparmor=0 
selinux=0 dyndbg=file mpam_resctrl.c +p", will be passed to user space.
[   17.707273] mpam_msc mpam_msc.254: Merging features for 
vmsc:0xffff08009b3aaba0 |= ris:0xffff0800a1d52c98
[   17.707277] mpam_msc mpam_msc.252: Merging features for 
vmsc:0xffff08009b3aac20 |= ris:0xffff0800a1d53098
[   17.707279] mpam_msc mpam_msc.250: Merging features for 
vmsc:0xffff08009b3aaca0 |= ris:0xffff0800a1d53498
[   17.707280] mpam_msc mpam_msc.248: Merging features for 
vmsc:0xffff08009b3aad20 |= ris:0xffff0800a1d53898
[   17.707281] mpam_msc mpam_msc.246: Merging features for 
vmsc:0xffff08009b3aada0 |= ris:0xffff0800a1d53c98
[   17.707282] mpam_msc mpam_msc.244: Merging features for 
vmsc:0xffff08009b3aae20 |= ris:0xffff0800a1d3d098
[   17.707283] mpam_msc mpam_msc.242: Merging features for 
vmsc:0xffff08009b3aaea0 |= ris:0xffff0800a1d3d498
[   17.707284] mpam_msc mpam_msc.240: Merging features for 
vmsc:0xffff08009b3aaf20 |= ris:0xffff0800a1d3d898
[   17.707285] mpam_msc mpam_msc.238: Merging features for 
vmsc:0xffff08009b3aafa0 |= ris:0xffff0800a1d3dc98
[   17.707286] mpam_msc mpam_msc.236: Merging features for 
vmsc:0xffff08009b3ab020 |= ris:0xffff0800a1d3e098
[   17.707287] mpam_msc mpam_msc.234: Merging features for 
vmsc:0xffff08009b3ab0a0 |= ris:0xffff0800a1d3e498
[   17.707287] mpam_msc mpam_msc.232: Merging features for 
vmsc:0xffff08009b3ab120 |= ris:0xffff0800a1d3e898
[   17.707288] mpam_msc mpam_msc.230: Merging features for 
vmsc:0xffff08009b3ab1a0 |= ris:0xffff0800a1d3ec98
[   17.707289] mpam_msc mpam_msc.228: Merging features for 
vmsc:0xffff08009b3ab220 |= ris:0xffff0800a1d3f098
[   17.707290] mpam_msc mpam_msc.226: Merging features for 
vmsc:0xffff08009b3ab2a0 |= ris:0xffff0800a1d3f498
[   17.707291] mpam_msc mpam_msc.224: Merging features for 
vmsc:0xffff08009b3ab320 |= ris:0xffff0800a1d3f898
[   17.707292] mpam_msc mpam_msc.222: Merging features for 
vmsc:0xffff08009b3ab3a0 |= ris:0xffff0800a1d3fc98
[   17.707293] mpam_msc mpam_msc.220: Merging features for 
vmsc:0xffff08009b3ab420 |= ris:0xffff0800a1d50098
[   17.707294] mpam_msc mpam_msc.218: Merging features for 
vmsc:0xffff08009b3ab4a0 |= ris:0xffff0800a1d50498
[   17.707294] mpam_msc mpam_msc.216: Merging features for 
vmsc:0xffff08009b3ab520 |= ris:0xffff0800a1d39898
[   17.707295] mpam_msc mpam_msc.214: Merging features for 
vmsc:0xffff08009b3ab5a0 |= ris:0xffff0800a1d39c98
[   17.707296] mpam_msc mpam_msc.212: Merging features for 
vmsc:0xffff08009b3ab620 |= ris:0xffff0800a1d3a098
[   17.707297] mpam_msc mpam_msc.210: Merging features for 
vmsc:0xffff08009b3ab6a0 |= ris:0xffff0800a1d3a498
[   17.707298] mpam_msc mpam_msc.208: Merging features for 
vmsc:0xffff08009b3ab720 |= ris:0xffff0800a1d3a898
[   17.707299] mpam_msc mpam_msc.206: Merging features for 
vmsc:0xffff08009b3ab7a0 |= ris:0xffff0800a1d3ac98
[   17.707300] mpam_msc mpam_msc.204: Merging features for 
vmsc:0xffff08009b3ab820 |= ris:0xffff0800a1d3b098
[   17.707301] mpam_msc mpam_msc.202: Merging features for 
vmsc:0xffff08009b3ab8a0 |= ris:0xffff0800a1d3b498
[   17.707302] mpam_msc mpam_msc.200: Merging features for 
vmsc:0xffff08009b3ab920 |= ris:0xffff0800a1d3b898
[   17.707303] mpam_msc mpam_msc.198: Merging features for 
vmsc:0xffff08009b3ab9a0 |= ris:0xffff0800a1d3bc98
[   17.707304] mpam_msc mpam_msc.196: Merging features for 
vmsc:0xffff08009b3aba20 |= ris:0xffff0800a1d3c098
[   17.707305] mpam_msc mpam_msc.194: Merging features for 
vmsc:0xffff08009b3abaa0 |= ris:0xffff0800a1d3c498
[   17.707305] mpam_msc mpam_msc.192: Merging features for 
vmsc:0xffff08009b3abb20 |= ris:0xffff0800a1d3c898
[   17.707306] mpam_msc mpam_msc.190: Merging features for 
vmsc:0xffff08009b3abba0 |= ris:0xffff0800a1d3cc98
[   17.707307] mpam_msc mpam_msc.188: Merging features for 
vmsc:0xffff08009b3abc20 |= ris:0xffff0800a1d2e098
[   17.707308] mpam_msc mpam_msc.186: Merging features for 
vmsc:0xffff08009b3abca0 |= ris:0xffff0800a1d2e498
[   17.707309] mpam_msc mpam_msc.184: Merging features for 
vmsc:0xffff08009b3abd20 |= ris:0xffff0800a1d2e898
[   17.707310] mpam_msc mpam_msc.182: Merging features for 
vmsc:0xffff08009b3abda0 |= ris:0xffff0800a1d2ec98
[   17.707311] mpam_msc mpam_msc.180: Merging features for 
vmsc:0xffff08009b3abe20 |= ris:0xffff0800a1d2f098
[   17.707312] mpam_msc mpam_msc.178: Merging features for 
vmsc:0xffff08009b3abea0 |= ris:0xffff0800a1d2f498
[   17.707313] mpam_msc mpam_msc.176: Merging features for 
vmsc:0xffff08009b3abf20 |= ris:0xffff0800a1d2f898
[   17.707314] mpam_msc mpam_msc.174: Merging features for 
vmsc:0xffff08009b3abfa0 |= ris:0xffff0800a1d2fc98
[   17.707315] mpam_msc mpam_msc.172: Merging features for 
vmsc:0xffff08009b318420 |= ris:0xffff0800a1d38098
[   17.707316] mpam_msc mpam_msc.170: Merging features for 
vmsc:0xffff08009b3184a0 |= ris:0xffff0800a1d38498
[   17.707317] mpam_msc mpam_msc.168: Merging features for 
vmsc:0xffff08009b318520 |= ris:0xffff0800a1d38898
[   17.707318] mpam_msc mpam_msc.166: Merging features for 
vmsc:0xffff08009b3185a0 |= ris:0xffff0800a1d38c98
[   17.707318] mpam_msc mpam_msc.164: Merging features for 
vmsc:0xffff08009b318620 |= ris:0xffff0800a1d39098
[   17.707319] mpam_msc mpam_msc.162: Merging features for 
vmsc:0xffff08009b3186a0 |= ris:0xffff0800a1d39498
[   17.707320] mpam_msc mpam_msc.160: Merging features for 
vmsc:0xffff08009b318720 |= ris:0xffff0800a1d2a898
[   17.707321] mpam_msc mpam_msc.158: Merging features for 
vmsc:0xffff08009b3187a0 |= ris:0xffff0800a1d2ac98
[   17.707322] mpam_msc mpam_msc.156: Merging features for 
vmsc:0xffff08009b318820 |= ris:0xffff0800a1d2b098
[   17.707323] mpam_msc mpam_msc.154: Merging features for 
vmsc:0xffff08009b3188a0 |= ris:0xffff0800a1d2b498
[   17.707324] mpam_msc mpam_msc.152: Merging features for 
vmsc:0xffff08009b318920 |= ris:0xffff0800a1d2b898
[   17.707325] mpam_msc mpam_msc.150: Merging features for 
vmsc:0xffff08009b3189a0 |= ris:0xffff0800a1d2bc98
[   17.707326] mpam_msc mpam_msc.148: Merging features for 
vmsc:0xffff08009b318a20 |= ris:0xffff0800a1d2c098
[   17.707327] mpam_msc mpam_msc.146: Merging features for 
vmsc:0xffff08009b318aa0 |= ris:0xffff0800a1d2c498
[   17.707327] mpam_msc mpam_msc.144: Merging features for 
vmsc:0xffff08009b318b20 |= ris:0xffff0800a1d2c898
[   17.707328] mpam_msc mpam_msc.142: Merging features for 
vmsc:0xffff08009b318ba0 |= ris:0xffff0800a1d2cc98
[   17.707329] mpam_msc mpam_msc.140: Merging features for 
vmsc:0xffff08009b318c20 |= ris:0xffff0800a1d2d098
[   17.707330] mpam_msc mpam_msc.138: Merging features for 
vmsc:0xffff08009b318ca0 |= ris:0xffff0800a1d2d498
[   17.707331] mpam_msc mpam_msc.136: Merging features for 
vmsc:0xffff08009b318d20 |= ris:0xffff0800a1d2d898
[   17.707332] mpam_msc mpam_msc.134: Merging features for 
vmsc:0xffff08009b318da0 |= ris:0xffff0800a1d2dc98
[   17.707332] mpam_msc mpam_msc.132: Merging features for 
vmsc:0xffff08009b318e20 |= ris:0xffff0800a1cd7098
[   17.707333] mpam_msc mpam_msc.130: Merging features for 
vmsc:0xffff08009b318ea0 |= ris:0xffff0800a1cd7498
[   17.707334] mpam_msc mpam_msc.128: Merging features for 
vmsc:0xffff08009b318f20 |= ris:0xffff0800a1cd7898
[   17.707335] mpam_msc mpam_msc.126: Merging features for 
vmsc:0xffff08009b318fa0 |= ris:0xffff0800a1cd7c98
[   17.707336] mpam_msc mpam_msc.124: Merging features for 
vmsc:0xffff08009b319020 |= ris:0xffff0800a1d28098
[   17.707337] mpam_msc mpam_msc.122: Merging features for 
vmsc:0xffff08009b3190a0 |= ris:0xffff0800a1d28498
[   17.707338] mpam_msc mpam_msc.120: Merging features for 
vmsc:0xffff08009b319120 |= ris:0xffff0800a1d28898
[   17.707339] mpam_msc mpam_msc.118: Merging features for 
vmsc:0xffff08009b319220 |= ris:0xffff0800a1d28c98
[   17.707340] mpam_msc mpam_msc.116: Merging features for 
vmsc:0xffff08009b3192a0 |= ris:0xffff0800a1d29098
[   17.707340] mpam_msc mpam_msc.114: Merging features for 
vmsc:0xffff08009b319320 |= ris:0xffff0800a1d29498
[   17.707341] mpam_msc mpam_msc.112: Merging features for 
vmsc:0xffff08009b3193a0 |= ris:0xffff0800a1d29898
[   17.707342] mpam_msc mpam_msc.110: Merging features for 
vmsc:0xffff08009b319420 |= ris:0xffff0800a1d29c98
[   17.707343] mpam_msc mpam_msc.108: Merging features for 
vmsc:0xffff08009b3194a0 |= ris:0xffff0800a1d2a098
[   17.707344] mpam_msc mpam_msc.106: Merging features for 
vmsc:0xffff08009b319520 |= ris:0xffff0800a1d2a498
[   17.707345] mpam_msc mpam_msc.104: Merging features for 
vmsc:0xffff08009b3195a0 |= ris:0xffff0800a1cd3898
[   17.707346] mpam_msc mpam_msc.102: Merging features for 
vmsc:0xffff08009b319620 |= ris:0xffff0800a1cd3c98
[   17.707346] mpam_msc mpam_msc.100: Merging features for 
vmsc:0xffff08009b3196a0 |= ris:0xffff0800a1cd4098
[   17.707347] mpam_msc mpam_msc.98: Merging features for 
vmsc:0xffff08009b319720 |= ris:0xffff0800a1cd4498
[   17.707348] mpam_msc mpam_msc.96: Merging features for 
vmsc:0xffff08009b3197a0 |= ris:0xffff0800a1cd4898
[   17.707349] mpam_msc mpam_msc.94: Merging features for 
vmsc:0xffff08009b319820 |= ris:0xffff0800a1cd4c98
[   17.707350] mpam_msc mpam_msc.92: Merging features for 
vmsc:0xffff08009b3198a0 |= ris:0xffff0800a1cd5098
[   17.707351] mpam_msc mpam_msc.90: Merging features for 
vmsc:0xffff08009b319920 |= ris:0xffff0800a1cd5498
[   17.707352] mpam_msc mpam_msc.88: Merging features for 
vmsc:0xffff08009b3199a0 |= ris:0xffff0800a1cd5898
[   17.707353] mpam_msc mpam_msc.86: Merging features for 
vmsc:0xffff08009b319a20 |= ris:0xffff0800a1cd5c98
[   17.707354] mpam_msc mpam_msc.84: Merging features for 
vmsc:0xffff08009b319aa0 |= ris:0xffff0800a1cd6098
[   17.707354] mpam_msc mpam_msc.82: Merging features for 
vmsc:0xffff08009b319b20 |= ris:0xffff0800a1cd6498
[   17.707355] mpam_msc mpam_msc.80: Merging features for 
vmsc:0xffff08009b319ba0 |= ris:0xffff0800a1cd6898
[   17.707356] mpam_msc mpam_msc.78: Merging features for 
vmsc:0xffff08009b319c20 |= ris:0xffff0800a1cd6c98
[   17.707357] mpam_msc mpam_msc.76: Merging features for 
vmsc:0xffff08009b319ca0 |= ris:0xffff0800a1cd0098
[   17.707358] mpam_msc mpam_msc.74: Merging features for 
vmsc:0xffff08009b319d20 |= ris:0xffff0800a1cd0498
[   17.707359] mpam_msc mpam_msc.72: Merging features for 
vmsc:0xffff08009b319da0 |= ris:0xffff0800a1cd0898
[   17.707359] mpam_msc mpam_msc.70: Merging features for 
vmsc:0xffff08009b319e20 |= ris:0xffff0800a1cd0c98
[   17.707361] mpam_msc mpam_msc.68: Merging features for 
vmsc:0xffff08009b319ea0 |= ris:0xffff0800a1cd1098
[   17.707361] mpam_msc mpam_msc.66: Merging features for 
vmsc:0xffff08009b319f20 |= ris:0xffff0800a1cd1498
[   17.707362] mpam_msc mpam_msc.64: Merging features for 
vmsc:0xffff08009b319fa0 |= ris:0xffff0800a1cd1898
[   17.707363] mpam_msc mpam_msc.254: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aaba0
[   17.707364] mpam_msc mpam_msc.252: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aac20
[   17.707365] mpam_msc mpam_msc.250: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aaca0
[   17.707366] mpam_msc mpam_msc.248: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aad20
[   17.707367] mpam_msc mpam_msc.246: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aada0
[   17.707367] mpam_msc mpam_msc.244: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aae20
[   17.707368] mpam_msc mpam_msc.242: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aaea0
[   17.707369] mpam_msc mpam_msc.240: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aaf20
[   17.707370] mpam_msc mpam_msc.238: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aafa0
[   17.707370] mpam_msc mpam_msc.236: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab020
[   17.707371] mpam_msc mpam_msc.234: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab0a0
[   17.707372] mpam_msc mpam_msc.232: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab120
[   17.707373] mpam_msc mpam_msc.230: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab1a0
[   17.707373] mpam_msc mpam_msc.228: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab220
[   17.707374] mpam_msc mpam_msc.226: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab2a0
[   17.707375] mpam_msc mpam_msc.224: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab320
[   17.707376] mpam_msc mpam_msc.222: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab3a0
[   17.707376] mpam_msc mpam_msc.220: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab420
[   17.707377] mpam_msc mpam_msc.218: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab4a0
[   17.707378] mpam_msc mpam_msc.216: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab520
[   17.707379] mpam_msc mpam_msc.214: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab5a0
[   17.707379] mpam_msc mpam_msc.212: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab620
[   17.707380] mpam_msc mpam_msc.210: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab6a0
[   17.707381] mpam_msc mpam_msc.208: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab720
[   17.707382] mpam_msc mpam_msc.206: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab7a0
[   17.707384] mpam_msc mpam_msc.204: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab820
[   17.707385] mpam_msc mpam_msc.202: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab8a0
[   17.707385] mpam_msc mpam_msc.200: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab920
[   17.707386] mpam_msc mpam_msc.198: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3ab9a0
[   17.707387] mpam_msc mpam_msc.196: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3aba20
[   17.707388] mpam_msc mpam_msc.194: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abaa0
[   17.707388] mpam_msc mpam_msc.192: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abb20
[   17.707389] mpam_msc mpam_msc.190: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abba0
[   17.707390] mpam_msc mpam_msc.188: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abc20
[   17.707391] mpam_msc mpam_msc.186: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abca0
[   17.707391] mpam_msc mpam_msc.184: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abd20
[   17.707392] mpam_msc mpam_msc.182: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abda0
[   17.707393] mpam_msc mpam_msc.180: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abe20
[   17.707394] mpam_msc mpam_msc.178: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abea0
[   17.707394] mpam_msc mpam_msc.176: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abf20
[   17.707395] mpam_msc mpam_msc.174: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3abfa0
[   17.707396] mpam_msc mpam_msc.172: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318420
[   17.707397] mpam_msc mpam_msc.170: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3184a0
[   17.707398] mpam_msc mpam_msc.168: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318520
[   17.707398] mpam_msc mpam_msc.166: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3185a0
[   17.707399] mpam_msc mpam_msc.164: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318620
[   17.707400] mpam_msc mpam_msc.162: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3186a0
[   17.707401] mpam_msc mpam_msc.160: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318720
[   17.707401] mpam_msc mpam_msc.158: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3187a0
[   17.707402] mpam_msc mpam_msc.156: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318820
[   17.707403] mpam_msc mpam_msc.154: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3188a0
[   17.707404] mpam_msc mpam_msc.152: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318920
[   17.707404] mpam_msc mpam_msc.150: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3189a0
[   17.707405] mpam_msc mpam_msc.148: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318a20
[   17.707406] mpam_msc mpam_msc.146: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318aa0
[   17.707407] mpam_msc mpam_msc.144: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318b20
[   17.707407] mpam_msc mpam_msc.142: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318ba0
[   17.707408] mpam_msc mpam_msc.140: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318c20
[   17.707409] mpam_msc mpam_msc.138: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318ca0
[   17.707410] mpam_msc mpam_msc.136: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318d20
[   17.707410] mpam_msc mpam_msc.134: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318da0
[   17.707411] mpam_msc mpam_msc.132: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318e20
[   17.707412] mpam_msc mpam_msc.130: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318ea0
[   17.707412] mpam_msc mpam_msc.128: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318f20
[   17.707413] mpam_msc mpam_msc.126: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b318fa0
[   17.707414] mpam_msc mpam_msc.124: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319020
[   17.707415] mpam_msc mpam_msc.122: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3190a0
[   17.707416] mpam_msc mpam_msc.120: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319120
[   17.707416] mpam_msc mpam_msc.118: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319220
[   17.707417] mpam_msc mpam_msc.116: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3192a0
[   17.707418] mpam_msc mpam_msc.114: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319320
[   17.707418] mpam_msc mpam_msc.112: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3193a0
[   17.707419] mpam_msc mpam_msc.110: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319420
[   17.707420] mpam_msc mpam_msc.108: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3194a0
[   17.707421] mpam_msc mpam_msc.106: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319520
[   17.707422] mpam_msc mpam_msc.104: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3195a0
[   17.707422] mpam_msc mpam_msc.102: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319620
[   17.707423] mpam_msc mpam_msc.100: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3196a0
[   17.707424] mpam_msc mpam_msc.98: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319720
[   17.707424] mpam_msc mpam_msc.96: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3197a0
[   17.707425] mpam_msc mpam_msc.94: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319820
[   17.707426] mpam_msc mpam_msc.92: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3198a0
[   17.707427] mpam_msc mpam_msc.90: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319920
[   17.707427] mpam_msc mpam_msc.88: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b3199a0
[   17.707428] mpam_msc mpam_msc.86: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319a20
[   17.707429] mpam_msc mpam_msc.84: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319aa0
[   17.707430] mpam_msc mpam_msc.82: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319b20
[   17.707430] mpam_msc mpam_msc.80: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319ba0
[   17.707431] mpam_msc mpam_msc.78: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319c20
[   17.707432] mpam_msc mpam_msc.76: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319ca0
[   17.707433] mpam_msc mpam_msc.74: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319d20
[   17.707433] mpam_msc mpam_msc.72: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319da0
[   17.707434] mpam_msc mpam_msc.70: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319e20
[   17.707435] mpam_msc mpam_msc.68: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319ea0
[   17.707436] mpam_msc mpam_msc.66: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319f20
[   17.707436] mpam_msc mpam_msc.64: Merging features for 
class:0xffff08009b233e50 &= vmsc:0xffff08009b319fa0
[   17.707437] mpam_msc mpam_msc.62: Merging features for 
vmsc:0xffff08009b3aa020 |= ris:0xffff0800a1cd1c98
[   17.707438] mpam_msc mpam_msc.60: Merging features for 
vmsc:0xffff08009b3aa0a0 |= ris:0xffff0800a1cd2098
[   17.707439] mpam_msc mpam_msc.58: Merging features for 
vmsc:0xffff08009b3aa120 |= ris:0xffff0800a1cd2498
[   17.707440] mpam_msc mpam_msc.56: Merging features for 
vmsc:0xffff08009b3aa1a0 |= ris:0xffff0800a1cd2898
[   17.707441] mpam_msc mpam_msc.54: Merging features for 
vmsc:0xffff08009aeb6620 |= ris:0xffff0800a1cd2c98
[   17.707442] mpam_msc mpam_msc.52: Merging features for 
vmsc:0xffff08009aeb66a0 |= ris:0xffff0800a1cd3098
[   17.707443] mpam_msc mpam_msc.50: Merging features for 
vmsc:0xffff08009aeb6720 |= ris:0xffff0800a1cd3498
[   17.707444] mpam_msc mpam_msc.48: Merging features for 
vmsc:0xffff08009aeb67a0 |= ris:0xffff0800a1bb4898
[   17.707444] mpam_msc mpam_msc.46: Merging features for 
vmsc:0xffff08009aeb6820 |= ris:0xffff0800a1bb4c98
[   17.707445] mpam_msc mpam_msc.44: Merging features for 
vmsc:0xffff08009aeb68a0 |= ris:0xffff0800a1bb5098
[   17.707446] mpam_msc mpam_msc.42: Merging features for 
vmsc:0xffff08009aeb6920 |= ris:0xffff0800a1bb5498
[   17.707447] mpam_msc mpam_msc.40: Merging features for 
vmsc:0xffff08009aeb69a0 |= ris:0xffff0800a1bb5898
[   17.707448] mpam_msc mpam_msc.38: Merging features for 
vmsc:0xffff08009aeb6a20 |= ris:0xffff0800a1bb5c98
[   17.707449] mpam_msc mpam_msc.36: Merging features for 
vmsc:0xffff08009aeb6aa0 |= ris:0xffff0800a1bb6098
[   17.707449] mpam_msc mpam_msc.34: Merging features for 
vmsc:0xffff08009aeb6b20 |= ris:0xffff0800a1bb6498
[   17.707450] mpam_msc mpam_msc.32: Merging features for 
vmsc:0xffff08009aeb6ba0 |= ris:0xffff0800a1bb6898
[   17.707451] mpam_msc mpam_msc.30: Merging features for 
vmsc:0xffff08009aeb6c20 |= ris:0xffff0800a1bb6c98
[   17.707452] mpam_msc mpam_msc.28: Merging features for 
vmsc:0xffff08009aeb6ca0 |= ris:0xffff0800a1bb7098
[   17.707453] mpam_msc mpam_msc.26: Merging features for 
vmsc:0xffff08009aeb6d20 |= ris:0xffff0800a1bb7498
[   17.707454] mpam_msc mpam_msc.24: Merging features for 
vmsc:0xffff08009aeb6da0 |= ris:0xffff0800a1bb7898
[   17.707454] mpam_msc mpam_msc.22: Merging features for 
vmsc:0xffff08009aeb6e20 |= ris:0xffff0800a1bb7c98
[   17.707455] mpam_msc mpam_msc.20: Merging features for 
vmsc:0xffff08009aeb6ea0 |= ris:0xffff0800a1bb1098
[   17.707456] mpam_msc mpam_msc.18: Merging features for 
vmsc:0xffff08009aeb6f20 |= ris:0xffff0800a1bb1498
[   17.707457] mpam_msc mpam_msc.16: Merging features for 
vmsc:0xffff08009aeb6fa0 |= ris:0xffff0800a1bb1898
[   17.707457] mpam_msc mpam_msc.62: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009b3aa020
[   17.707458] mpam_msc mpam_msc.60: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009b3aa0a0
[   17.707459] mpam_msc mpam_msc.58: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009b3aa120
[   17.707460] mpam_msc mpam_msc.56: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009b3aa1a0
[   17.707461] mpam_msc mpam_msc.54: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6620
[   17.707461] mpam_msc mpam_msc.52: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb66a0
[   17.707462] mpam_msc mpam_msc.50: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6720
[   17.707463] mpam_msc mpam_msc.48: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb67a0
[   17.707463] mpam_msc mpam_msc.46: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6820
[   17.707464] mpam_msc mpam_msc.44: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb68a0
[   17.707465] mpam_msc mpam_msc.42: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6920
[   17.707466] mpam_msc mpam_msc.40: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb69a0
[   17.707466] mpam_msc mpam_msc.38: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6a20
[   17.707467] mpam_msc mpam_msc.36: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6aa0
[   17.707468] mpam_msc mpam_msc.34: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6b20
[   17.707469] mpam_msc mpam_msc.32: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6ba0
[   17.707469] mpam_msc mpam_msc.30: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6c20
[   17.707470] mpam_msc mpam_msc.28: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6ca0
[   17.707471] mpam_msc mpam_msc.26: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6d20
[   17.707472] mpam_msc mpam_msc.24: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6da0
[   17.707472] mpam_msc mpam_msc.22: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6e20
[   17.707473] mpam_msc mpam_msc.20: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6ea0
[   17.707474] mpam_msc mpam_msc.18: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6f20
[   17.707475] mpam_msc mpam_msc.16: Merging features for 
class:0xffff08009b230050 &= vmsc:0xffff08009aeb6fa0
[   17.707475] mpam_msc mpam_msc.14: Merging features for 
vmsc:0xffff08009aeb7020 |= ris:0xffff0800a1bb1c98
[   17.707476] mpam_msc mpam_msc.12: Merging features for 
vmsc:0xffff08009aeb70a0 |= ris:0xffff0800a1bb2098
[   17.707477] mpam_msc mpam_msc.10: Merging features for 
vmsc:0xffff08009aeb7120 |= ris:0xffff0800a1bb2498
[   17.707478] mpam_msc mpam_msc.8: Merging features for 
vmsc:0xffff08009aeb71a0 |= ris:0xffff0800a1bb2898
[   17.707479] mpam_msc mpam_msc.6: Merging features for 
vmsc:0xffff08009aeb7220 |= ris:0xffff0800a1bb2c98
[   17.707480] mpam_msc mpam_msc.4: Merging features for 
vmsc:0xffff08009aeb72a0 |= ris:0xffff0800a1bb3098
[   17.707480] mpam_msc mpam_msc.2: Merging features for 
vmsc:0xffff08009aeb7320 |= ris:0xffff0800a1bb3498
[   17.707481] mpam_msc mpam_msc.0: Merging features for 
vmsc:0xffff08009aeb73a0 |= ris:0xffff0800a1bb3898
[   17.707482] mpam_msc mpam_msc.14: Merging features for 
class:0xffff08009b231150 &= vmsc:0xffff08009aeb7020
[   17.707483] mpam_msc mpam_msc.12: Merging features for 
class:0xffff08009b231150 &= vmsc:0xffff08009aeb70a0
[   17.707483] mpam_msc mpam_msc.10: Merging features for 
class:0xffff08009b231150 &= vmsc:0xffff08009aeb7120
[   17.707484] mpam_msc mpam_msc.8: Merging features for 
class:0xffff08009b231150 &= vmsc:0xffff08009aeb71a0
[   17.707485] mpam_msc mpam_msc.6: Merging features for 
class:0xffff08009b231150 &= vmsc:0xffff08009aeb7220
[   17.707485] mpam_msc mpam_msc.4: Merging features for 
class:0xffff08009b231150 &= vmsc:0xffff08009aeb72a0
[   17.707486] mpam_msc mpam_msc.2: Merging features for 
class:0xffff08009b231150 &= vmsc:0xffff08009aeb7320
[   17.707487] mpam_msc mpam_msc.0: Merging features for 
class:0xffff08009b231150 &= vmsc:0xffff08009aeb73a0
[   22.876035] mpam:mpam_resctrl_pick_caches: class 255 is not a cache
[   22.876039] mpam:mpam_resctrl_pick_mba: class 2 is a cache but not the L3
[   22.876040] mpam:mpam_resctrl_pick_mba: class 3 has no bandwidth control
[   22.878500] mpam:topology_matches_l3: class 255 component 0 has 
Mismatched CPU mask with L3 equivalent
[   22.878503] mpam:mpam_resctrl_pick_mba: class 255 topology doesn't 
match L3
[   22.878505] mpam:mpam_resctrl_pick_counters: class 2 is a cache but 
not the L3
[   22.878505] mpam:mpam_resctrl_pick_counters: class 3 has usable CSU
[   22.878506] mpam:counter_update_class: Updating event 1 to use class 3
[   22.878508] mpam:class_has_usable_mbwu: monitors usable in 
free-running mode
[   22.880995] mpam:topology_matches_l3: class 255 component 0 has 
Mismatched CPU mask with L3 equivalent
[   22.900111] WARNING: drivers/resctrl/mpam_resctrl.c:1495 at 
mpam_resctrl_domain_insert+0x74/0x80, CPU#2: cpuhp/2/25
[   29.755844] pc : mpam_resctrl_domain_insert+0x74/0x80
[   29.760886] lr : mpam_resctrl_domain_insert+0x34/0x80
[   29.842897]  mpam_resctrl_domain_insert+0x74/0x80 (P)
[   29.847938]  mpam_resctrl_online_cpu+0x2b4/0x428
[   29.852544]  mpam_cpu_online+0x274/0x298
[   29.941348] MPAM enabled with 32 PARTIDs and 4 PMGs
[   29.977840]     dyndbg=file mpam_resctrl.c +p


With the exception of the issue previously raised in patch 26, all other
aspects meet expectations. Please apply my reviewed-by tag to this patch
series once the patch 26 issue is addressed as mentioned.

+ Reviewed-by: Zeng Heng <zengheng4@huawei.com>


Thanks,
Zeng Heng

