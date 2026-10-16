Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011037.outbound.protection.outlook.com [52.101.52.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E347CA6E
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 23:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792191961; cv=fail; b=cZpjtU7PaIeYTvn7woGnivJNWyxq5dS3OOf1OzUkf8H+wVJHthphjRQktLLzWNkDrKIVoOdeEzX/n/zZOXNjj1biMtmFSXJn0CzNjuq+s//yhjNGdo394LdGk+k9n5VM2T06wH7TSpjDDOCJbJjw4LVoa2FmWo/22BYn4yQjJdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792191961; c=relaxed/simple;
	bh=4UAxaeZPU2MsdkePSs4/IPmuCgPR9VflX9oTCDp/VVs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CV/jfvtvkNxeLIyL1Zr2H2Q4EpuGH7nYMQUcvikSsrlk2LT8PAQeilgVw9gaYB8QE+Q3vBGhH0b+kJMSrDgM4OJ4GYI+C7H0/P5c1P351Dg2RFXTY6So3sK0IIbxRHRG6+K/q5FtqDFDbEFrHDTj+kVzB9BL6oq9AQcfvQovjN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=grlSIrx5; arc=fail smtp.client-ip=52.101.52.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="grlSIrx5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZC1/HwhkWiefHwFgBjC8Pw34fUk64BHknHP4e6sCQxnqjrJnkYAIZIFBlAloNotq+FnsFgh6A/3NUovFq8hzpmvjjBzWqV0PsrqaOfc4vDsvjKuRBa9wRuXU44/zJbcpdJzoMLeO553nHtqap0lX8VsU3v335b4ufd1tarRGUZNFKZCKYxRUTToCvG0WxAj2nXPHUreRVGYdnYkNEqdxtcHSGnsq1XCmSnc1oTeath1avcokZffd/AenODIdCWSwECaBykW5DxXVy9KxIBZqpUrSbJiEZV5s4dDOPi5IYMRn//xeLev8EZjWm5OmWpjP4j8g7uwNsWjLnGhhcIOOyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQiwG3l/lMKHybtHjCIhCA8ZE99dp+VVT9vCu+Ln+fc=;
 b=um9oB9rg2Ep4ampWo4806MSLjPMqbiZ9iCTpAgsOsRZ9YwvekyCgEHXHfRiOR5HCzLHg6Lolt8Dx5qzT6UcWUOwpFbqQb1AqZW3LANxIi4G8pGGN6apsmBzy9/EEzWqVvqZpgDS/Pgwpew2+ydgj5jR7rMNi/M3asUZTyAinywj3f30MwV3ccDTbPV+T3CHUqbEnLGEf8/EMX9veevfc2+FBKyLeO8Wcv5Yyz2UWegHm/uh9vXN00uasTWZx2+lXDXgC0ZUE0ZE+gcbAMJgt0SYALcueNVu57XOu8TyMfGSZucPW/j0AppaKT47bIlBrP9+AjCYlPmvAti1B/QmQyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQiwG3l/lMKHybtHjCIhCA8ZE99dp+VVT9vCu+Ln+fc=;
 b=grlSIrx5xmsbqATTw9k75BMAVLk8gz42a7P/+LIY41UNCGniQ5b+zpMIEOviKLlDswAeqKOouOUOpjhIKdYuY7e4Ytk3vdtr3FvhEKACpUcoxoQ09yAFVUOO5t/anuX+kauXvVTs4VWXI4sQVE7omcnyv8zkVRdUybvr698114jhFthu5zwH+FWYqwCaPRS4rxShKvZnpe9yeLy1aYnFoHvoqXgNht8xg2hIYQwDnIpj75KMZ4XSgCJRxnfWQmQHbdL1GZ5csq9XjZwgw1dnCR23gFTe9IYEdooj5LrL/OXqlWMXij4Qvrx3LNKGlJRftXporo4GBN2nOcyKpNA2IA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5201.namprd12.prod.outlook.com (2603:10b6:610:b8::21)
 by CH9PR12MB167381.namprd12.prod.outlook.com (2603:10b6:610:314::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 23:05:51 +0000
Received: from CH0PR12MB5201.namprd12.prod.outlook.com
 ([fe80::fa53:495c:c3d5:243]) by CH0PR12MB5201.namprd12.prod.outlook.com
 ([fe80::fa53:495c:c3d5:243%4]) with mapi id 15.21.0522.012; Fri, 16 Oct 2026
 23:05:50 +0000
From: Deepak Gupta <deepagupta@nvidia.com>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	pbonzini@redhat.com,
	mchehab+huawei@kernel.org,
	jiaqiyan@google.com,
	oliver.upton@linux.dev
Subject: [PATCH 0/1] target/arm/kvm: handle KVM_EXIT_ARM_SEA
Date: Fri, 16 Oct 2026 23:05:40 +0000
Message-ID: <cover.1792191544.git.deepagupta@nvidia.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:806:23::7) To CH0PR12MB5201.namprd12.prod.outlook.com
 (2603:10b6:610:b8::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5201:EE_|CH9PR12MB167381:EE_
X-MS-Office365-Filtering-Correlation-Id: 0919bbf4-a07d-4b0c-4fe3-08df2bda0574
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IkiZ4pvuzYv7/G/vrJuBChwckQ+aBYxNLSnBryPA6xHn+/axESqKOo5T97DZIdnKozyyLJP9Uh1thGHBD/Mio9nvv4jVijykD5vpzIK92Jzf+Z+rUV1kc9+8DXB5Ab9kJEBGo7bprzQ4S0bgKSbaw6hFm34I5jl8UfWYiok3UoGBx0whaFgw69WW17/63jY+Pw4HOXzG/imxdAngpvx6fyS6sDkCo8SfethtCexSn71CDSiKadTjPumjwmhv9E9P7EXnnIfUlXOUgt8o6970IA/TuoJKIwhhSal2L1P4VnXO+bFK5cZH9fbizZybMjeQAuzhdXuQAIyt90+SxmKTWF8vQsVJT03nKIpxfHh5x952cQYJcAKeGhtXRd+A9delf9lodINAG1FHc2bL44kmGZfPepqypGsSj5K96jvpXIbY5irfRarnx3MGqPTDPN49/DqMCC3d+DV8Lh0ZDbp4PxYUZ18FNOqAnw5THKiKvxqPbf/PY0CHtKz7rHR41qy0uTMee8Uk6KNzOnkR/ZA5KhonA6vSfus77QXiO1dY0MwLxnjGmAnvZLdzoY9ihaRAGyspW/kCV3MhG+T58l72+pQK2eupBlCq9lq4F81NHUaG6/JmM6N2CJNxfvjl5jvQ3badIdrfoAHrqftXKnlPcybyo70H0SK/bPBxFYs/tj8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b73gkxGDSgEhYRmTGn+XlnMkpp/wgtyctdBexf4qH6KtrCUhC9YbpbYBZiXH?=
 =?us-ascii?Q?Vt+9wiHyxaKXXIhobYMNOSCpVx8J+qQ0iw+orlll0lDqlBE56tMcQvaxScH0?=
 =?us-ascii?Q?3S9sRCeTh58jXBSx3gP7X4O8NHGKvrH8cDXaybTLk4MQvBDU+X8KqperSpqt?=
 =?us-ascii?Q?dZ4g2p8c5YyPRE6CMFpoFR0ldMdQiIupbi5pzIE9Owxyd6xV5w68qKbBYJPv?=
 =?us-ascii?Q?ymvh/ZudhA0Xh9NQdwQ5QGWRE8cvtuM7IgXMVX/mrkQuN4nhjA+fZl2PLGeH?=
 =?us-ascii?Q?c3ExKSb/b+8oTstyRplZcssBJJ3AdO+IWdLjwlO+R3IiGIoZs0jbPYSB7A09?=
 =?us-ascii?Q?w84/O5OY7QJe0wdp2GXY9CQvh3CfzJzjAQ236aJ6NlRjLeBcOYAIjSgLo2gr?=
 =?us-ascii?Q?/ZcZTeX9j0S33xK7H7BxFlzp1CdFi/yrtPdyOG7o0o51cOdbVywrNzFmNN9Y?=
 =?us-ascii?Q?X26t+n2b1Z6rinaGz+S6R3nPCO6KKdW6aqqI0GFH9H2685/JAlnb2Y5FqRQA?=
 =?us-ascii?Q?+w74oXl3kzSr/TIPCmXh/pf3FP7lNH7OQ+fH8OcKDHA/Jw9i/f0HrsqUCGp8?=
 =?us-ascii?Q?n16gZzUc22djLR6kFCOS/8rh4SCkBamKe5oJDUx3Qa/7X+7kUuqMpeF3F59S?=
 =?us-ascii?Q?mKAwtODSeRDfrRQoFsSbHYJ8osBIFzo1ZFoVK8Px0hraZTpf6gr5Hq8JgXrJ?=
 =?us-ascii?Q?UGUoAUZwv6e/PQuVSalu28z5nNRb38Ilf3cFVNUJat0y2BmYwNqcfkqLu6+J?=
 =?us-ascii?Q?FP6CBGLdwHmCx2bg1rVEnJwPvEsOEvZx6KF3dnZNjg3tocsqFJriPOPIFB1B?=
 =?us-ascii?Q?zvebkr1CCtbliHnZc0Ue3fjmGaPwWIVZTLu35un/97QDngls8ocxu4oO0KZk?=
 =?us-ascii?Q?AfjIyH37THv0mOJ4wEJOxm219EeKQFz6kORSsaqiGjmJNWrCVeupD70TLP/e?=
 =?us-ascii?Q?o0MGbfjC8L1hvuOI9Yy5eLEuP9FAxIzocR3Txa7XQIzZUe55vaZZEWeCKkkV?=
 =?us-ascii?Q?GNJWLFLx0YolH6OCoUrbwg6sFoHKgfAKniTpcIg9k58axsVpk0540nnD7rVO?=
 =?us-ascii?Q?qHX3+QLuPqWRNVctpBuWXBSlBhgdNMgS/fVP5RbEDDJ86izFiMTCiRB7gBTm?=
 =?us-ascii?Q?DUpN7hy2u0ublRiiNS4uzqYT+6pbP+CFpl6kZZ/B1yOGpaOLJaklneizhEXW?=
 =?us-ascii?Q?qVQ07/YNaSn5Wpqk+1NpLJqvVs0oPcdllRl40speduVnIAR1ZsxURy+2hL0q?=
 =?us-ascii?Q?J3vgW/ehiw/VfVwAqSA/LqsedykpNP+kEGxwp2RCD0srj56LU+S0py2HLoQ6?=
 =?us-ascii?Q?y1R+qxYCuQSV3qJr/i8+FpDy/iB4XG0mdUSxV+xm7ARybF8ePbJddnaK9qd8?=
 =?us-ascii?Q?E2RiU3pznJP2U30+a9rXqzDvevmZ3WUwTbHTxQwshezlA/jXC6kp62jgCmzW?=
 =?us-ascii?Q?wRq5qhjVcQe07CMQBXpAYiX0O4DjVJNdP3dqv4RrOcaisK0Z1uGZ2OjvUWE+?=
 =?us-ascii?Q?o8HEeuOtjHjsH4ut6jA/eiSso+KrOWnFl7BPoj1+bJlUoivUP8/kRZCDciM6?=
 =?us-ascii?Q?FGsoZBxrcGvzm5WmQgsAMwX4OgIeibsiFRpZbzY8IfYFPKXyH4bPqqqdfzZa?=
 =?us-ascii?Q?SlzXjvklkLXBWYm3dx7TPtgLMAWLTHh1MpuHmFjhBtTdJtqFTPI9cW+ilc9E?=
 =?us-ascii?Q?K5M5gPjkDqHxKWMzhmSlCKPMD0KlPtMHzXt3aJiA6tm3g+9kv1IUu1X5PuB8?=
 =?us-ascii?Q?4D/h/xweXA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0919bbf4-a07d-4b0c-4fe3-08df2bda0574
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 23:05:50.5643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iRV1/xyUqdczX0t81bTG2g+1ZabXNeQrLSnOwFJDaBa4tx8cdZmZ1Tbbwz8rHXpBt5fuJrvp/Tj2+Lj02Otjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR12MB167381

Hi,

Linux 6.19 added KVM_CAP_ARM_SEA_TO_USER [1]: with the capability
enabled, KVM returns a guest synchronous external abort that the host
could not claim through APEI to userspace as KVM_EXIT_ARM_SEA, instead
of injecting a virtual SError. QEMU does not consume the exit yet, so on
a host whose HEST has no SEA-notified GHES source every guest-consumed
memory error still ends in a guest "Asynchronous SError Interrupt"
panic.

This patch enables the capability, handles the exit by recording a GHES
memory error (when the exit carries an address backed by guest RAM) and
injecting a synchronous external abort that mirrors the original one,
and wires up the BUS_MCEERR_AO SIGBUS case so the guest learns about the
poisoned page asynchronously when the exit itself carried no address.

Points I would like feedback on:

 * Injection: I reuse the existing kvm_inject_arm_sea() route
   (arm_cpu_do_interrupt() after kvm_cpu_synchronize_state()) and let it
   pass the sanitised ESR fields (EC, IL, FnV, EA, CM, WnR, xFSC, SET)
   and the FAR through to the guest. KVM_SET_VCPU_EVENTS with
   ext_dabt_pending can only produce a data abort with FAR taken from
   the last exit, and the documentation restricts it to MMIO/NISV/
   LDST64B exits, so it did not seem a good fit; happy to switch if that
   is preferred.

 * The BUS_MCEERR_AO record goes on ACPI_HEST_SRC_ID_QMP, which ghes.h
   documents as being for QMP-injected errors, because it is the only
   GED-notified source the virt machine has. If a dedicated source id
   for host-originated asynchronous records is preferred I can add one.

 * With the pre-10.1 single-block HEST layout (no GED-notified source)
   the AO record is dropped with a warning rather than written into the
   synchronous source's block.

Testing: arm64 host whose HEST has only GSIV/SDEI-notified sources,
EINJ uncorrectable memory error into a page mapped by a guest, consumed
by a guest process (-machine virt,ras=on). Before: guest panic. After:
SIGBUS to the process, GHES record and hwpoison in the guest, guest
stays up. Also checked: the pre-existing BUS_MCEERR_AR SIGBUS path still
works (it is taken when the host's memory_failure() wins the race),
ras=off (bare external abort to the guest, no record), -machine
virt-10.0 (the AR path still delivers the synchronous record, the AO
record is dropped with the warning),
check-unit and check-qtest-aarch64 on the host.

[1] https://lore.kernel.org/r/20251013185903.1372553-1-jiaqiyan@google.com


Deepak Gupta (1):
  target/arm/kvm: handle KVM_EXIT_ARM_SEA and report BUS_MCEERR_AO

 target/arm/kvm.c        | 164 +++++++++++++++++++++++++++++++++++-----
 target/arm/trace-events |   1 +
 2 files changed, 146 insertions(+), 19 deletions(-)

-- 
2.53.0

