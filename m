Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5979757EB
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 02:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729132764; cv=fail; b=Pn8oJB1dZzc0QCCNZ2MbLbwNe0NGX5/YOnsPBnbKffXy/LclSVoOGgR6mMaKVgTDj9AEE/yaaznBM6QqNgY8JI1dSCgzpMOag0jg9IVazCmvBAKxvLBMJSlm3k+WedyO3QFPESpEgql8uQMSmTWgl//VnwnmT8uQVrCKvdUX+mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729132764; c=relaxed/simple;
	bh=WhFw4I9kVCreV3Tk7/Wn7pKX4jT3LCgyqlsSo+IUZk0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 Content-Type:MIME-Version; b=Y3x6FNJnQoQ1euR9rQn5I0syruMB8nC4fJg7815+KteVP55poORDgS29akpy87XnzNdf88qVO3zUH6G0H3r+6TkLrHGrR8cBpCL/jfH941kvb6Os2rZmzJmPLmvVf+r8otDfmfk/qV49wcmsc1kjQ7rQPoRlo32W+cWt2pX/l1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=QPnxuH5d; arc=fail smtp.client-ip=40.107.223.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="QPnxuH5d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sVxZbP9+BhwQP7f1L6InHv3WXPBRTlUv/jqnDz+oktVQpJqtEby7W3XIxfvZ/9GYFcJtnP0d9s3d+vExTJziZoVloZ8ZtbBem27Fp6fsfRea+roF0dHbOxN6WIfuxaD5z8z9puO3MjivkwrwWeEqbDwXCGexg3rah8sdWKfh+S+iBouCXVW6N0jGryRHbLKfV6hgFyNKJAccxA96t2GMhzvBVz02ddQ0LaamvkGLheOqnG63lBNnGL+tsHI+pI2K3zyz9hoxMN1QyfbbjpWWT8XNf5t+gmq+2PgFwdPxHqGa8xwbu4dfwGHAII3sFR0Yuz5bH3Jsv0D0ZHfoFX7wpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifMFbKar3GkUbrlKoA8Sq1dihyY08QuryFZmuC1yHoY=;
 b=P2UFJ/DGMexiaJ+a32bPFlAu3GBjlbY1UPjtam6rAYQX6luVR35lhtK4oaUJKhALML4pZWLn6TCDYfJL0mV8p5OrjwcIuicPqPceDxpicKj87TbIIHw4OGkI1JjUT2c9LbBA8QS9qPb0/Fy/2PEekp08rwDS0FpNXDbPQgDiOfwKqESAyLKGoNMd3Z7y1lETcSRWhAWlem+Jgkclr/GbJbzqSlO4LR07RJm+fpSIw31kt/HrOpJjZb2j8EjLBqgxpoxbCJnvDHJ2zjnj9ilJ3mfjguKkc5JgBYB7FYVcBFYlqsoRg2Ds4Ijh2Ym7pd2QEMhj1MxgfEd6N3n6AhmzsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifMFbKar3GkUbrlKoA8Sq1dihyY08QuryFZmuC1yHoY=;
 b=QPnxuH5dZIB8Ixq1C5pWBQvB6SM52U+6jcgz9hTv2EGR1nPAiQP9wNENt7LKhs0Pt+HE06ug98VrAUWyr29pSuRtiDjapNxKnX3319hXA6zAsNFFQjOdK0oUUrpcmWBWLmXr4g+22W0xlcuOSxOkBTQj8wN00kang5KUGHbkd+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from MW4PR01MB6228.prod.exchangelabs.com (2603:10b6:303:76::7) by
 MW4PR01MB6193.prod.exchangelabs.com (2603:10b6:303:73::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.34; Thu, 17 Oct 2024 02:39:15 +0000
Received: from MW4PR01MB6228.prod.exchangelabs.com
 ([fe80::13ba:df5b:8558:8bba]) by MW4PR01MB6228.prod.exchangelabs.com
 ([fe80::13ba:df5b:8558:8bba%7]) with mapi id 15.20.7982.033; Thu, 17 Oct 2024
 02:39:15 +0000
Date: Wed, 16 Oct 2024 19:39:05 -0700 (PDT)
From: Ilkka Koskinen <ilkka@os.amperecomputing.com>
To: Gavin Shan <gshan@redhat.com>
cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>, 
    Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
    Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Akihiko Odaki <akihiko.odaki@daynix.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix shift-out-of-bounds bug
In-Reply-To: <ab5ef80d-0e74-4a39-ba76-536b7d095b40@redhat.com>
Message-ID: <995936c7-a556-bd77-e9dc-48742f78a91f@os.amperecomputing.com>
References: <20241016195755.65011-1-ilkka@os.amperecomputing.com> <ab5ef80d-0e74-4a39-ba76-536b7d095b40@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-ClientProxiedBy: CH2PR19CA0019.namprd19.prod.outlook.com
 (2603:10b6:610:4d::29) To MW4PR01MB6228.prod.exchangelabs.com
 (2603:10b6:303:76::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6228:EE_|MW4PR01MB6193:EE_
X-MS-Office365-Filtering-Correlation-Id: 6395ce24-3c40-4a99-7384-08dcee54e418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|7416014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MwEiBlovFxu27t5x9dD6OOcfmbJ2LbSFOhOCDZhOMif3djHds+EP7N99QFRY?=
 =?us-ascii?Q?xVW4imQxzNs1zcIBVGFCSgFedF2mcjNEpyJhE452HvmC2KWaRWAGIqSaJ6NJ?=
 =?us-ascii?Q?Rta9MeYDBD1h33d5DAznE0OlKTQzN1t96bdp4B51f4zNCWDEqLUlJcyv1H3v?=
 =?us-ascii?Q?2Iz7L1Z2XRpdLqeQTtZWDY6w6+Bee9QBh/r39f5larF5HQDq5WPacDdiQggu?=
 =?us-ascii?Q?pUlq03DDB7FpFbGmp68Nw0chBfxClduvH+h8p4reJuVD03eQmozdPNUV3khr?=
 =?us-ascii?Q?pJw0OkdJZHg++vmjIZdb/Sy/Uts89JnB3C1xDb2eCRU/e04TeLjxEMd+I5ru?=
 =?us-ascii?Q?1mox4QXfKof+Lbu4NgV314adOV5ASYNYx6Sg9Y+Yz70TDyNpjvkDd6il2s/V?=
 =?us-ascii?Q?kKLhWlgoEeNe2JDlZDjEob57u2pWxEUGcoYztEH/3JMQ5uXZVQivxP1T4tUX?=
 =?us-ascii?Q?fzzs07N0CkXDwb44Y3MwRUGUH+VQoowXYDKicURV+3wR2Zk/255ISOv8GL9M?=
 =?us-ascii?Q?srHQLQWl+2lN/JmPTa1tZ+aSNCBVXhGmtSq9njbrNOwrS4tlyV+Ou9i4MLM0?=
 =?us-ascii?Q?mpe3/bxFrwbH8Kwf6QmxBoSdswOQv+p+pa6VREQu5mSfsJWmTOFQLn0x5Ps6?=
 =?us-ascii?Q?IU36mW6gp3LthxEcnuMOr6CfutsPiTpvdc8Sqo5w2psXj51dDTobSNH2WxWZ?=
 =?us-ascii?Q?XOge2H6QFriqNp91oYEP242x2ZSDqLxMPbvj1Ta5epsEm143hKoRLO81Ox4e?=
 =?us-ascii?Q?AZFXx7+lk3tRetCUQlCj6NKd42LCkBXDpzYWoUUTesukxwboWboG5iF3jjf9?=
 =?us-ascii?Q?41JaPXVms1MT0zeiAiFReyvedXcxPZ17tCNlj6PX512BcwdaTutIzR0k/7QF?=
 =?us-ascii?Q?VLXisVs4GubHlMgXgXWBanVepnIJ/cR/toYdHTH4kCGsNoAiWobu3oeUpvEm?=
 =?us-ascii?Q?b5yGCUgNkFX53P+fSoqlQBo+gIMZfC2JxC5iJM9UungYrl1DcxzDpB0ffzO/?=
 =?us-ascii?Q?HuW05LmJ1HVRZNd6QfuQV+w1BPglmDzrYpLqJx0Klq2BShSfkvytk4p/nk4M?=
 =?us-ascii?Q?BXe8E5+MNY0QrHhS7zNj6MGDadZRHv5uuTJ3t73weW3xceYumf9twIXF4XQe?=
 =?us-ascii?Q?52T0hXhnrjL6KZygywto8KND8QBEbTX1+ynUIAl4j2e0vgdB8A9FrZfJexh1?=
 =?us-ascii?Q?YSFhZVM1ChyLefBDH+BRdQxWBicrfHXj7D6AFtm5SOAzZwj4YLMF21mSM0iU?=
 =?us-ascii?Q?rA+pIp8L7dvyB+Fx9GL39sDVBS1A+YHnKKRyqW+cOOCbCfmJrb6X0S6un7P6?=
 =?us-ascii?Q?DSm4Cggt/PySrktSR/7br9uw3MUkngTQIU6dIfpD9DshMAIDIV+M9qkQD6x0?=
 =?us-ascii?Q?gST0NRI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6228.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(7416014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b7sY2LynKK8s5yCHO8RK8uufFwfE1sd8sMvGGrf84x4pgen/g6JagMAG1oV1?=
 =?us-ascii?Q?4TijVYtT9rrTcbAIaYkwQbfM866y7b6Zp0cneuHiHmeE6w2rF9Al8KYDwXHx?=
 =?us-ascii?Q?yr+iHqBbxy6qYfMMVNBy0hcsDnGZUSEdlTY9NB+yao18bFwhLfi/AArtS5Yi?=
 =?us-ascii?Q?43zmPeLqzxlNeVfCDmx27o4xB2xkSpvScnEqH4Yt+OjzaiiVmi2qXe8hE7nH?=
 =?us-ascii?Q?Lb+teiayzoAjkahTZ8TKBMvlFZsoEuSGvfmDiijy18TQIldgCp6e6R7NqPSd?=
 =?us-ascii?Q?kgrSkJGrixV5uFRHkVUDrMZSrvJlqTiwFyp8QK/8lgF1GtNq1BfmM+sVl4D2?=
 =?us-ascii?Q?XVUzwiSRB27zp+YScjweadjl8mcncZZOrfepkz3TLTL+zHbSbjzm9g/kKmxW?=
 =?us-ascii?Q?mzOpqYtCPOqAs1e7gaeHlg/uci6+SUJyynZwkxQxQGJVo3IeEHVDspp6U/Me?=
 =?us-ascii?Q?pjthct2t1ceKyiRVBizJJ/IdWbBT6/18gqsLHqGDx4WKflh1riTFpDr3e9LN?=
 =?us-ascii?Q?VjIMjOI5YWizetqIZvmMpajur6nPnULkAMK8/8D7kqNYYQ964vDtXGPmU5m6?=
 =?us-ascii?Q?jt8eSl3861WbKC+BQoEsZexXf2AmlAx1Uv+OV+OlzvVvQsVzZXtqtsmhNWqP?=
 =?us-ascii?Q?qvwOk6Ub+E2fWTNiqMAqvqfUuKzYG6e/5q7/6wck28qP7qbteEvmK1eyY2Yg?=
 =?us-ascii?Q?VPLnVSH/MXM3CEaoAlGCHzQG6wNu0hfF+JOuZdEgK9/Axw8hfCzQYnyCo1oz?=
 =?us-ascii?Q?Z1GlhdPGTN7UkX4MTJHr3BR2ksmmnrPjLnw7Md5NCGWi+5r7JboNzRuoY9Iu?=
 =?us-ascii?Q?SLIvtr9nBRmZZw0ycCBAnoO2fe9ueI/ub7eb5HL9EFDQTOE0ESyW9sOyVt3j?=
 =?us-ascii?Q?2hQhdAu+/36t46Cd0zcEPmiyliFEmXhXSZDbhK9jSTeNBU0XORklXZdtArRS?=
 =?us-ascii?Q?sCEKJI0X8fKzesgb+PQNzaf+slchzarqi7hh8vykQSTuahCgvQNw3VgFJnJY?=
 =?us-ascii?Q?NNsc1NWg7RTasC/AcjFY2ewg8j1mEXl+TRz6aU6L1ag9Awg2agq50SE4LYz6?=
 =?us-ascii?Q?cob+vNI5UrlGrFOmUaF3f/IBNX4sQ6HZwEo92LJ6vaRhhqwL/lyW9Zy4MkBM?=
 =?us-ascii?Q?JOOmKvL/ss1pyRwqiRZFjDq66on8k+YBvM6HykvFEhJD2gl3OWMf45XhBsHQ?=
 =?us-ascii?Q?SKIBHKZ/ptnBLUACVwtWz2DBWJxFIzXlRNw+JdgQMpbjdna7hCSu5KwvhL/O?=
 =?us-ascii?Q?sTaZlrCMELGOouEGKF9wGiaZF3N8L+KVyjqfbWi+XCjdTfN+wF2C/Arm8tlg?=
 =?us-ascii?Q?rJlTRNSbZQfkWjFab+FE19vwBp8WIyP6s134DTSiiLrhIHfnBtz6l/iodbif?=
 =?us-ascii?Q?LsD+eC6+nG53muSFfDTuPieQlmZEaW2CGzpFHNXGbHXyD9Cia27BmnTY8TgY?=
 =?us-ascii?Q?LGE7J1XCKR40mwhh2+61bRa3+/t50xysx+E/pDSAxVv9xmSCBRTgZ78Khij4?=
 =?us-ascii?Q?aeavI5/Yg1Pec4TTv4hLd/+R7kT7mQPQ7rM7Oma82no2sdX+PcDxqzTcR1bM?=
 =?us-ascii?Q?Nr8nkfIFrCSdW31BUFRNLdbG6Tw/nMoQ546aExqGsapWmWvemZklmDVbC9X5?=
 =?us-ascii?Q?+/bUs3dZ/bCbF3REtUsypg4=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6395ce24-3c40-4a99-7384-08dcee54e418
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6228.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 02:39:15.3325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HpXZsi5UqWAbZkJmALR3rzFCiNDGJBeJeHIJlQSynlb1bQqNv/IbrBlnrozlkxJaBPDasqqTE9kns4WzyJOGnHgVx1HU65qT6f9i7CvKTPyhyBZ1WOyvchkieDgOUY0A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6193


Hi Gavin,

On Wed, 16 Oct 2024, Gavin Shan wrote:
> On 10/17/24 5:57 AM, Ilkka Koskinen wrote:
>> Fix a shift-out-of-bounds bug reported by UBSAN when running
>> VM with MTE enabled host kernel.
>> 
>> UBSAN: shift-out-of-bounds in arch/arm64/kvm/sys_regs.c:1988:14
>> shift exponent 33 is too large for 32-bit type 'int'
>> CPU: 26 UID: 0 PID: 7629 Comm: qemu-kvm Not tainted 6.12.0-rc2 #34
>> Hardware name: IEI NF5280R7/Mitchell MB, BIOS 00.00. 2024-10-12 09:28:54 
>> 10/14/2024
>> Call trace:
>>   dump_backtrace+0xa0/0x128
>>   show_stack+0x20/0x38
>>   dump_stack_lvl+0x74/0x90
>>   dump_stack+0x18/0x28
>>   __ubsan_handle_shift_out_of_bounds+0xf8/0x1e0
>>   reset_clidr+0x10c/0x1c8
>>   kvm_reset_sys_regs+0x50/0x1c8
>>   kvm_reset_vcpu+0xec/0x2b0
>>   __kvm_vcpu_set_target+0x84/0x158
>>   kvm_vcpu_set_target+0x138/0x168
>>   kvm_arch_vcpu_ioctl_vcpu_init+0x40/0x2b0
>>   kvm_arch_vcpu_ioctl+0x28c/0x4b8
>>   kvm_vcpu_ioctl+0x4bc/0x7a8
>>   __arm64_sys_ioctl+0xb4/0x100
>>   invoke_syscall+0x70/0x100
>>   el0_svc_common.constprop.0+0x48/0xf0
>>   do_el0_svc+0x24/0x38
>>   el0_svc+0x3c/0x158
>>   el0t_64_sync_handler+0x120/0x130
>>   el0t_64_sync+0x194/0x198
>> 
>> Fixes: 7af0c2534f4c ("KVM: arm64: Normalize cache configuration")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
>> ---
>>   arch/arm64/kvm/sys_regs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 375052d8cd22..665c576faba3 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1994,7 +1994,7 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const 
>> struct sys_reg_desc *r)
>>   	 * one cache line.
>>   	 */
>>   	if (kvm_has_mte(vcpu->kvm))
>> -		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
>> +		clidr |= 2UL << CLIDR_TTYPE_SHIFT(loc);
>> 
>
> Nit: It's more precise to have 2ULL since the type of @clidr is u64,
> equivalent to 'unsigned long long' on arm64. The pattern ULL has been
> used in reset_mpidr().

That's a good catch. I change it and submit v2 right away.

Cheers, Ilkka

>
>>   	__vcpu_sys_reg(vcpu, r->reg) = clidr;
>> 
>
> Thanks,
> Gavin
>
>
