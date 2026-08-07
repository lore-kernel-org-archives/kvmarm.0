Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011055.outbound.protection.outlook.com [52.101.70.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A257434E42
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102237; cv=fail; b=TJ1wCXtzOwvt8e+eIa0hHxT8fP47/yFOPoBWlC2ntdmU5cup1AxmaXFb/YX2dfcsLsj4zqogp0PCNAOmkalFva6EpkizCVWSYezes9F2ZsiiHBwmHMUKXHxYYExEDCA8EKCz7vu4EVARbVam4zkVjAmOT168atOY+LgWHOk4Q9k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102237; c=relaxed/simple;
	bh=FU0vZKkJ3fKqQ7b8o+lnUqxalTPwOWlBXdciGkrFsnQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oTu8vxAKuoDN4TC0GK+w0fKFieqi+F4Nk0UhqBIkMAf90sjsl2qFXaWtRRymaIDhAIXqpVn9iXzDnzEgWo9wyKtW7gH+wiXedtXinRwe5GndYmsS1+xdcmYdJT5IBENFVlLZ6bHMDSEeRdpxi2wh7GwHaBb10tuJ1S850ppL7TQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JTbEHJEW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JTbEHJEW; arc=fail smtp.client-ip=52.101.70.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JTbEHJEW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JTbEHJEW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kpAxsUnvBxIeqCpy6KMY+SX6Z9X6HZqGVi3MBWkZbMFngGSTmg7iQk4xG//L5VUKzS9cxdzC95Z8YvWp2rcYxdYhzUzzz5Cs3azhM9gU3Z5yHGuZxfMVieRS3Jbg3gOA12m3H80PX3XWsnmzWEwlp1phamLL+pYSYFlyUL6Y/ToxCo2pTQz8e9BOCKF0X3iJccyBa1Ontw//lVCEAL9O9aZSdJrNUVWXfXDhxePWjfNNg/vJ6XzuBYWITEuqiNOGK2ATmCHLUkIK2hYNK2+mbNQqPbkdEmEn1b0Oxs2giJEHyb6Y5136mcmxgFgteni+Ci9myNC9Fou2H77ycHY61w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0NvcoAZO5Fn8KnLhhlo0Xs/oDi1WT66bdv6/0N4bZc=;
 b=N6dkn5OYAu1xYmdTtqdEpxuBiNCcgzT/8zqWnOScC1k4Wkt/m3NBBCjzh2xBnVzVwJoWXOeMW1EQsXMTovKw53XF2gtSwUqqbFBfnlfxAx9p97lQQxs7h99FZG/jPOMQK+GXd0/KtHbQ7KUZAe9g+wsUrSHLx94RBq3PiIWwFg5m7b499lNrG3AhDfSH5YHz3JyAzCa1LJuXOP5wvjOYFIBP+fsqYnWkmWjroH530DP1cxOwW3xieyRvttEYLezo5ScDnwYpLJqye5AgjG89YaMQQz8N+MkJRZ6VZRejbMaKdvXpRkrrRiiljwvL+chWjSP+KlG2T9iad31R5WZyVw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0NvcoAZO5Fn8KnLhhlo0Xs/oDi1WT66bdv6/0N4bZc=;
 b=JTbEHJEWbp9hak2eO3Y9XZhRzaX/xArZHl1DVqUlXonDhwyFX5g0gbLFBkerJruiboecTsGf8V7jR0NATlR+f8QSpxJ+/Yt3w7to9pGjKSDOPOzVxtXY6S+aXjSyPVVkVlAHhdEJxmXyvkAmznmKWxtViRX3MIOMh1q+XVRm6og=
Received: from DUZPR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::11) by DB9PR08MB9514.eurprd08.prod.outlook.com
 (2603:10a6:10:452::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:30:28 +0000
Received: from DU2PEPF00028D11.eurprd03.prod.outlook.com
 (2603:10a6:10:46a:cafe::26) by DUZPR01CA0084.outlook.office365.com
 (2603:10a6:10:46a::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:30:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D11.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:30:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+Un1bw2Jows70e22nPO9biuvCp9gW6wJGsrqgKVBaybaW9f4mWYUh5wgQBxG9lObTCY4knUc7r0ZeiZ8L5+11MGoAGEZdA29WrxLbNFd8DB6lE81DYeFhc7xD5s0FmJRZbMANoaICDjGfJp7jgkLRgNFlRY6K+mKV7U3laK3GfPXauvDqLbmtJIviPZz85uN3vcVnnH8wVbi04sb6ohy8h32LrG0q9GoJZ/Oy57teCz00ydyvZ5pPZygaLZzFkS1UOTWQDk1EdqX20q3cVnEpcI+vPLXV6W/p1clbHK8IUIBD5h2IKbSbwovD/mxerQNwyPwsOGPROimZ9WVzvb7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0NvcoAZO5Fn8KnLhhlo0Xs/oDi1WT66bdv6/0N4bZc=;
 b=sB2wqZW1dAcHJe/qA+sS2IZdXenMJjgoelah8HC/gPdZmzla0pqDyy+zWiKQrWb9z9AojIGHmhOH97KryEwVdzcNHwWr6Dc5v2ruTt58mJlBQY8CTu0HIwCg6aNkP6rjVbAW1K1JIfTO5m203qJ0QKiRdKOfz3b+jHPY9iGUPxCYPc8QbYty5J109GOCarTeu/gxfG1bvSPLRQt0QU9S3KcSuuYioQpwIpmz13WRAQcjPB8U4C6yfnm5hDzKuBvZpfKV/kcnBhNP5wU4hT8n9gfmi9LjJrQA4z3xp1Du7hbAW5W0xiNhphVLrihPNw/2/osmRGGLB1Ib/Ly+gc87Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0NvcoAZO5Fn8KnLhhlo0Xs/oDi1WT66bdv6/0N4bZc=;
 b=JTbEHJEWbp9hak2eO3Y9XZhRzaX/xArZHl1DVqUlXonDhwyFX5g0gbLFBkerJruiboecTsGf8V7jR0NATlR+f8QSpxJ+/Yt3w7to9pGjKSDOPOzVxtXY6S+aXjSyPVVkVlAHhdEJxmXyvkAmznmKWxtViRX3MIOMh1q+XVRm6og=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:29:55 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:29:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v5 34/49] KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
Thread-Topic: [PATCH v5 34/49] KVM: arm64: gic-v5: Add VGICv5 IST save/restore
 UAPI
Thread-Index: AQHdJmAR/W/7R/IQfUK/DzVQvtdk1Q==
Date: Fri, 7 Aug 2026 11:29:55 +0000
Message-ID: <20260807111159.429128-35-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|DU2PEPF00028D11:EE_|DB9PR08MB9514:EE_
X-MS-Office365-Filtering-Correlation-Id: b31acfd6-ef64-42b2-a310-08def4774828
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 iivAOPguk0AJXRU2Ym/AFKlUHNzQhXKEHXyCJQomz9J3I2+R5DXNR/2TzuVIgle4ytTxtls85WSRBDZzD5NYG+OcwAyR7+S/Gps5Hdc3RmoAcwbwNJTGAmu5mJvIKG8h3VtZs8CdRXZDaOHgygIOFj3RxWoF2xPs17fduBfZG8tiGNHjELWBmV3Qs53xq4NpCgyvJkhI2eEKknj1svfBD8CNwd38K7FBrFN1X9SfNkegi4KHPWg15lAlfKypzdtQBaeVeBkZ9RwmOeNPpZEb6Q1EpGkCjF8Ope4LXMagwMTIPfHWtVsgXgcd6zONsEWTaunO4T9mF4fW9q2WIbt7Zs6H3yaRTCb8FR7Vvni9Za6b3ZuBLH4LJJ17vORU76Nwd2RYHAO2XXIHfxN3nIznT5DdegzkA7q3COsLJM72/XaZkORm7GjnVaghUHNPEI9LT4Kq6zfTy1gxSod7uPMIeUCf1b62gmXdj+LSdi5ZRKzwknlHBNmxqZ4RM4FQQf9+haLcLcfmXQ+CdTyh2/z7aQ/MHjnk4M8wnh8qy62P1tTbkES0P6GYiw3UuJHOj6BOWTo/G9DFJ2S203erL3nPB/z5c037HUdsy351hYIkg1N9hcLv6zVa6ZjAG1Q6A35EVHd0lYvKLe1Japf46eiBd3EmyCgrrzlAHHnnoZVlxRoo+TrUPCWg6+NxJncPF+I6XtE9Y43mef15v+lk+5PxzjBlBMksdEpa6EAXy3WLzwM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 daPxsfGx9kr4X3z4IGsPhFRZU/BNz8uJ1/SPNPxY7lD0mBJeeky78Ph6RvjljfLuVGYH79kSmSv+qA0SF8pXq8qVmixp0ReKDilQQk8QwJYihsvNPC/bI70KTkiUpjNdn4Mou9OUwW9f3akTh3IQQxhijY64/PReMgten+xIrdVtan1u8aOwLPMaSUxUbwIAESZiE3Z1+85vfY7QOfqKHH8KONR+gb1Za3yNMSfUdbdZ6p+VTQgpPVONYna1udkfsx7eTxArLpS/u4A/bXWiu+63RVuyftjz0gZpBbWxkVheTy7lu8p72ePWBoIvGKEIvZJIIoCtULlINx1pzjvrlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	107c23b7-111c-4fe0-e178-08def4773479
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|36860700016|14060799003|1800799024|82310400026|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5Go6h+mzvBLQ4d44JRpOScY1Rm9J2t6MmvsC6I2pJ3qHCGHJBFYzwC/79WtIKhaOej2dXZg7HE6PsNF5HQt7Qr0nCu3BHEZlFzmDCv75ZI4SX33likkiMAyhjNJ6zEGPP8gxMStVh7V8rHzJXQFws3uAEpx+N5Hhg4jF2MRalUx/8zSGvVYbWyd0wzxQq9b9GHBz2TiYMTdqgf7LfiKf9XWwbamOmeigOqgoBGejjosxu6VOQUQ6etdWyI/vAqSM8h4KBDe7wAsYNa+LXeRBi1wbzujcQrtBhGC0ajP6Q5YXpSHc1BCv6w4AFHjTmmMe/GYwiVbuZJesD72hTC2rSr1h+RzL6OMxh3WEahY2boaaAHOz9fl03oEoqg0zZJj8A2n9jEublJkzmyHI+HkL1tJk6Ydp+OaZiqasMsmAibru57qRM93BSnpzoRTJ1yfsJEh9u+C7ESoaLrMELc64rrV9UL46vKnpPfl+RKqznmPVej6MQR5Xh/A5JjBiFBVOq2IN2tnIgr4s384MB6OpU1ad5hsblFK1kFfQIsrMmtPjs6VQBWyTTZnRMN8wnDywuhBOUu1ZflXtrj08D41hfDXozDosvn5kBcaQDMyeqfKFYHh/O8PsxiROddo4HIS7Jd6tHi88noRt8ZCbMwHjFPTrU9by3d8vLfONqwzjAyx7QpR2cxm8Uwd0x544rD2Acwx7daNkrDNrtM6/eb+nhw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(36860700016)(14060799003)(1800799024)(82310400026)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Q80yOGe+HVY6nQJ0H/r2PC2TUXpMXsqsl5MaFL4SrAYeUaJi+27AaAe4RVSBtnMZ8rvHSab4CTBBu7EM1h+cUz4vY51rSEXUdg91YygeKBomY5DJpDFCtp+O0VfAtuqEYmuElT3mamBt7HIK9un/el+eyjtweAtWQvKi3O+JX2Dfk320rOXk4yOBpbBtwJfm8ZUMCbDUOiTpCWBO/0iknmza8+RLPaPyLggM/rlyiWAQdBUHk57dJQw2v4aQ3WNo6tVrAN8q49RkDf/9kvn5YkVWr5Ksv38n/xDC3E+nNOIoU8uqo4mGqTeXnsb/pWhS4xfwLLKeV8Wec0xHLPfXp0hn+HoEkIQ/SRD5wD21CQ+0GvrozatdVd5wPUuUA15xeRZxRM54XHFef44E3txSjnG+aG7pUJqZIxDq7Rbd2SRfUDgwPuJc1AHXCDhzQMWB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:30:28.1095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b31acfd6-ef64-42b2-a310-08def4774828
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9514

Introduce KVM_DEV_ARM_VGIC_GRP_IST as the VGICv5 device attribute
group used to transfer SPI and LPI IST state between KVM and userspace
during migration.

The group uses struct kvm_vgic_v5_ist as a descriptor for the
userspace-owned SPI and LPI IST buffers. Each buffer contains the
architected 32-bit ISTE state for the corresponding interrupt number
space, while the host IST layout remains private to KVM.

The descriptor is architecture-specific, as it is only the payload of
an ARM VGIC device attribute.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 9 +++++++++
 tools/arch/arm64/include/uapi/asm/kvm.h | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 710a0d267347d..9998252ea8ec8 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -423,6 +423,15 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
+
+struct kvm_vgic_v5_ist {
+	__u64	spi_ist_addr;
+	__u64	spi_ist_size;
+	__u64	lpi_ist_addr;
+	__u64	lpi_ist_size;
+};
+
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 710a0d267347d..9998252ea8ec8 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -423,6 +423,15 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
+
+struct kvm_vgic_v5_ist {
+	__u64	spi_ist_addr;
+	__u64	spi_ist_size;
+	__u64	lpi_ist_addr;
+	__u64	lpi_ist_size;
+};
+
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
