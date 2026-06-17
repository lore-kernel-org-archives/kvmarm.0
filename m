Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010045.outbound.protection.outlook.com [52.101.84.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4102A3F9F56
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781703771; cv=fail; b=q8sIJ/qITSKOS5aJiJTviBppv7Zhak5C70hKFHW1jUesXim8y3z4fea98EcMGeDcK3cPpztyMX5Tmx8hUpsO2gxFf8aNNk9Sozo3qE+/xEoAdw3txzwvw9ViAqZn1fNfjMOgyPwlMUDLnjIdvhb2HH447uvU9o9EfUm4C60uRhY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781703771; c=relaxed/simple;
	bh=XxlY8fhBWbSYqPTIiWq0VC11KW6eRBWMK5UT0adIisY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b7F6lB7LR+C1XlYRngAlzibuxBSPMIy59I0KJp+9hNDC7NaUOZKScllP7XjLJ3+JfQ6CMYXYWjnyc21kdiffc0ECytl/j6pMxudQYtYAXxSTI4F4ZlG/g26XzbVDSgOV5dECibU/I/WvXkz149xD/qRgAmSkb1WjpmNzXjCvIxM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LrSYWQ4O; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LrSYWQ4O; arc=fail smtp.client-ip=52.101.84.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LrSYWQ4O";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LrSYWQ4O"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OzLifMQyV/UnHZqkULefmyRtKcJcJvv9astLnVt2z+nozzPjuv/r7xW9zND6yzkPCFiwJbAka7SSyqgsouaEEQPIqQiuOjRiICLN/9qoKOVsV20QpdqULCcVghcunWxK4S08ll4ceYRY4h2dpKyLaNH6V2gVThEsQ3Zc8odSm+bw7fENRjJRpzRXwPy5Igt18iqCmHUh9Ujk4vn9bxAnPMOd4yCRXpiE3bQHQeEICJ6LsRMpgKrJT892aOhj5BQ/ghML4D9A/CIg3zxACJrEQP7eS7SeBWa2/rHupNIdfPTGUwAfCB31uWW+DWaRr0r99y5XYjhtXMSit0Y8EGH0MA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGvRHndryVMe4VFTxLb7/VKb7cg/87B8UD5EUBKOENc=;
 b=E/TA07IOOvjel+umeVoq21bWADEi9Nd2k3bUc1SEg2GDSQdGDVVttA0vl0CZPpfBXhXGi3gWJFpwtyXcmD5vbxjrQQarlQuzkpcni3uTuRkEvIloGWTL4zsDSVEXMoD+YTp7ThjwhNlEkgBkWnZF54OxXwM9lYKnYrm6Eq366por6gZtFicut0sVu8XZdTEW7lnkir7HEd24m8unDoBfkQYTzAvDtdLzHuGTqXAj40EgwFSd6eK8UQpD92Rr/4kiALzwIvHF0Bg6fcbFGe0LFvLbV6DO+Jb7mJb77W/BCJx2d41H7cCrAVAsAM7FzngqI58++BDq5aopZ4lO/I2lrQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGvRHndryVMe4VFTxLb7/VKb7cg/87B8UD5EUBKOENc=;
 b=LrSYWQ4O4nDO6Wc7milcvaHUgfww7/kpi58Fh3EfrbNISjA0nhCJM4TTF8e4whRWANeRw1nju5DEI01IrjbtTX9Z2Kjx6RVvzHgmGwlG0pSwMYlNxao/Xke6z9oYVWTeAx6K2fsnUjE7nsJiJUCmRMJ/64ZbZbOK0Ed+m/VZnAI=
Received: from DUZPR01CA0038.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::12) by PR3PR08MB5690.eurprd08.prod.outlook.com
 (2603:10a6:102:86::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 13:42:45 +0000
Received: from DB3PEPF0000885E.eurprd02.prod.outlook.com
 (2603:10a6:10:468:cafe::6c) by DUZPR01CA0038.outlook.office365.com
 (2603:10a6:10:468::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.11 via Frontend Transport; Wed,
 17 Jun 2026 13:42:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885E.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.8
 via Frontend Transport; Wed, 17 Jun 2026 13:42:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPcDZ6RjoK6t/IemQZKhYd9GZ+k1U06SfVi9zOtn0vGmq1yengbMIoPeMMDslfOIpX9sxTq5Vai9Y8NYnEDMkHFVXyI8T5EvZgkqYZwAZZpfWhMXWYGJ2F/54L0wC4B0x7ILXlBaNittKiPI3BQgHAOhgRSlxxS1eNYGTgqxwo5B0loKEAZ5olOK2THH5cOhd0cDpXtt/DcmVKpDf0gJQDhgIJWvAIbaXwCieo/Twpjr7qOzAxxmD0bGrqA9ctjC2Syfk8zjsGQGWlGqAbJ89KLhP4J4oV74qydEIa6dwLIGtK1PNA6C8AiE3cORxL4/Enbdq1UnryKN8bWKg/BkSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGvRHndryVMe4VFTxLb7/VKb7cg/87B8UD5EUBKOENc=;
 b=FOPvitZm+kk/M7zs/Cl99K6jMWRNPof0krKz/QC/DtscBhH5jNQe0WfT82b4nbPKqg88Poi3n8isyHYzAHNfzBeZtCE/+7xjiQM8Gl3nDyryUWHlLh1Fgcrawy1AHD1m7KWD618qyr0bOON4eMDq+NwQjoXE072KdQDeJDWnZ53ZaEpzVKJzZRAAwxJIqXpXsLe+SS8HvvGh1ocTJVq1ekT1i1BVJ6M551l5DivoXHvM06Id+S+P/l4v6gHUZa5iwBOa0gr7myWej0ZdnsqEQhggiUp+EUYwIdzpPBPweAjdLzPYC+tVX9SubzfbLW/ZhvNW12FG8ONGgQBe92alXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGvRHndryVMe4VFTxLb7/VKb7cg/87B8UD5EUBKOENc=;
 b=LrSYWQ4O4nDO6Wc7milcvaHUgfww7/kpi58Fh3EfrbNISjA0nhCJM4TTF8e4whRWANeRw1nju5DEI01IrjbtTX9Z2Kjx6RVvzHgmGwlG0pSwMYlNxao/Xke6z9oYVWTeAx6K2fsnUjE7nsJiJUCmRMJ/64ZbZbOK0Ed+m/VZnAI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by PAXPR08MB6382.eurprd08.prod.outlook.com (2603:10a6:102:15b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 13:41:43 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%3]) with mapi id 15.21.0113.015; Wed, 17 Jun 2026
 13:41:43 +0000
Message-ID: <3b1cda8e-96d2-4b66-9916-caef7762209e@arm.com>
Date: Wed, 17 Jun 2026 15:41:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 seanjc@google.com, mark.rutland@arm.com
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <42323088-c06e-42e2-b095-136062a8d27c@arm.com> <ajKf41Fgy_jKBAMI@raptor>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <ajKf41Fgy_jKBAMI@raptor>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0680.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::9) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|PAXPR08MB6382:EE_|DB3PEPF0000885E:EE_|PR3PR08MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 0051b8c9-4878-46fc-f41d-08decc765017
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 Cy4ffPNm3isuaToPJNDazSN1hwIGOhf2gj6b8tgapnyEq4M/IQrymjLN+ibp0q8U6riZp0LKoHvJHqudEyzVIQCzpnYrHoWLudS2Jx8V+DLbVfqSdzBoppsZ9nYBnLNPw9VY8+zLogKPU4ofdJYjdUEMMksFlLJOVsysgfy0J7CxIpTglFeKmf+H5LaCHZWcMyyivJZR86i6lrzWuirudN8BQG7KIfFMIxBITGoqPmBPqpu4dbMamPt9c7sa6SWUWzKciMxnvP8k4p7vd2mc0d5FoPY4mPbQaS/wKT+eDLr+bLNy7xGzmnvB898JjGJ/NPVMLxH7yP7CthcgPoFOdM8rQBdp+Pci+WSQf2Rf7tChRstVLyrtGAWWczRfj15QI+eaePJmHSMbu/vV2fo0YG7W7Yiuv11gIP36pAHGYMKnvGq/Dn7ba8oyVEWiB71ajy0YwqjMkLaLgMIpI599Jqd4vwuMPpmzwA46NeENmue2XjU7inAVAaNfJv6q1D4AV7PpFIz7xfRS0dmoQkcn8ClMgsaCUqLQFRdh7+wge7AQFBgKL/plnf/0Y+4lBFA0DHNmFtieOfFLmnCwQjAi/Q98ocjV6gRZ7T8qGcrWF78SmpGcZnR16vQl+4E1zrTnS63UbFD/0jEYcg52wSsdbbw9DxLuJ6lxwb8TbPFfqGqKBDM8D/RLhrFvtcU0U2hO
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 VVFW9T8y0lj09hsPPgz2rXwqbGq+xWXbSWlL9C2kuPQKu11qkvMtdS5m2QnRCry951XlId6puhQQERtBnSkr19fXLlZyomVaYwCMoL0zUWu7gXGqvLxqDhqmOLe0uNh4Kr6wJtEV3v6sXWxtv3+XfZZWktjzygRX7IOoE1bsIQx/azSf7NG37YfnFiTGLr16Wn53Z9aFlgudCqDiF3ikORL4ZPxwbQxOzAv8ERlqvZ3KqBafHfiOwx6/vCKwha4rl7jXi47Z8skGwkg4LbIktHwdCXu+vuWsI8E076uNrAgrCAHwWxhd5u+MARDO9TNk/h+TgpcKsqO6tEudHyYqVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6382
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b4107c8e-47ba-4fac-e857-08decc762aa3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700016|23010399003|1800799024|82310400026|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1gQxdrOPMa0+UPiL8b/zyyZoNGEQ0zhBTVaNt7IStwfocsInGZCsfEcJZDAben7Jj3UUw+juyJDESd0jj65GLpsnl3yp69J6eB2Lpg4rhP/jMLgJ19+YWn7HTxl9o+7a0wVZtASLVNP2N1tJnRJeFRGTB+hQrcnN9VQVC6DbG9H4MB0bfzrABvhavg2GTWFUKP8QAEKaQwHP+BUu6Gg0bdmwSXyjzSDI150ni0y/ffkKtB0RpuzA/vam/h4+YOju7Vlsb6sXTx9RlBBqhX3Ix6BGrR3/KORwktvk9X+l6D7qQt/84iMu8BqVeehqYezxDenabzu5jkoopprFfSxc9ZCyT9oLviXQ+4/SA5YIkXY9CAwhtJN7yYku56JXQ9lAwQUMJAX0YVor4OnLZOS7B3p2/V8a8xFmuJaQ1KrT7cxVXegY1P3/ZdXVqOxnWNAJ4H8h3nxpzzwVyLODGr11CrXcVf2Aobkpr8tqigp6h1sLpLUjeZ0Wk1bv0vcgxNpt25kuHq+V48IMVYMWEWH6RoKmOo6ZK47Hm18D7l1itrxPerPoAdhKN0QGjPhYqc/eVHCjKBJVgH9MfnJ5xLfpGS6GydXp3qL74lmgJmT9da2zF1aZfDoG1eYpPvQ88zYC92w94u/rXmcgkCTSWIqJxpb823R92dmw45Rv3cNSIZlIlm/0iTUg1De6SOZADwrc6W1m66d7EPoYKCIAUOV4oTX8rjasYuLzYHr/eiNAreE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700016)(23010399003)(1800799024)(82310400026)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5IFhDEfTAQ92Q/G9Gll5lN/doAc6Y4NPVWgbEuvSN6YYYf4YuuJ2zYmYX8/XpfhIiwHHOvwlQoUUDQXZfcQWELXuXBFX/EoRs6tlJ7dEY8BWoqP1/xZshufEE29dVM1XUPE2BU1f4Eaxem68s1RU3PQjg/F+vNFo8bGRE3ALK6+Wr9LcdR25U7hniDzJqvguVom4u/f5P60c+Yz44USyZ+7GX0Hd7ZCMsx7GLx+1ZNurIfXE1kPVJFKMLaC5gkSUJMr/c5aXhphDe+7NngS1I0z9N82PK27q7wMbML8QeT0xLsnwRwAt6BwLEABVhqSnpJNW/koWfEHugDGEzWBp7/t7Pt9eejoKi69CGWPmlt0QsFt1rHOZq/T2Sbn+hj9axvICiyFldMPWHfZjg5VmzoeJbDJqVVrknAK0LzYvmbjJUdnCGXf/CI1y0zUFQ80h
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 13:42:45.4065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0051b8c9-4878-46fc-f41d-08decc765017
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5690

On 6/17/26 15:23, Alexandru Elisei wrote:
> Hi David,
> 
> On Mon, Jun 15, 2026 at 09:07:50PM +0200, David Hildenbrand wrote:
>> On 6/15/26 17:52, Alexandru Elisei wrote:
>>> For guest_memfd-only memslots (kvm_memslot_is_gmem_only() is true), the
>>> memory provider for the virtual machine is the guest_memfd file, not the
>>> userspace mapping. Faults are resolved using the guest_memfd page cache,
>>> and the permissions for the secondary MMU mapping depends exclusively on
>>> the memslot (i.e, if the memslot is read-only). How userspace happens to
>>> have the memory mmaped at fault time, or even if the memory is mapped at
>>> all into userspace, is not taken into consideration.
>>>
>>> guest_memfd memory is not evictable, is not movable and there's no backing
>>> storage. Once memory is allocated for an offset in guest_memfd file, the
>>> offset will not change, and that memory is not freed unless userspace
>>> explicitly punches a hole in the file. As a result, memory reclaim, page
>>> migration, page aging and dirty page tracking for the userspace mapping
>>> serve little purpose.
>>
>> I don't think any of that is relevant for the patch at hand?
>>
>> The thing is: invalidation (truncation, later migration, for any other reason)
>> is driven through guest_memfd notifications, not through unrelated page tables.
>>
>> If we don't lookup pages for the KVM MMU through the page table, then there is
>> also no need for MMU notifiers. It's all guest_memfd only.
>>
>> Or am I missing something?
> 
> My thinking was that, because guest_memfd is not evictable, there is no need to
> do page ageing, which would require that secondary MMU mappings be made old.

Not really.

The KVM MMU did not obtain the folios through the page tables, but directly
through guest_memfd. Any aging would, therefore, have to be done through
guest_memfd.

Which we don't support and don't want to support :)

That we happen to have a matching user space range that maps the guest_memfd is
just coincidence from a KVM MMU point of view.

> 
> The invalidate callbacks are also used when userspace memory is marked read-only
> for dirty state tracking. I was trying to explaing that, since there is no
> backing for the guest_memfd file, host doesn't need to keep track of dirty state
> for the memory, and ignoring the invalidate callbacks is correct for all cases.
> 
> I can drop the paragraph entirely, if you think that would make the commit
> message clearer.

I think the real motivation is:

"Mappings in the secondary MMU were established by obtaining folios from
guest_memfd directly, not by looking the folios up through the page tables
through GUP. Consequently, there is no relationship between the page tables and
the secondary MMU: MMU notifiers do not apply."

-- 
Cheers,

David
