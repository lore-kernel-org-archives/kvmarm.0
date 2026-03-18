Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013029.outbound.protection.outlook.com [52.101.83.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C0D3AD529
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 09:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773827657; cv=fail; b=IwTyVh6E5RXAAFGYk6mjEjfDdI3RRwtHIrOW0ACzKK0wn+G6IRqCNUf069oQbtDrUfG78NOqt8Wwk60478IqMZmDr8fFuEm+Go5iZUs2ed7E33Y2MMasWRpAVDB+J2rf9LiShdeyVWzIEuFVpagslEnrpRUJX+iZrCSTfY2YAgI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773827657; c=relaxed/simple;
	bh=veKIVzF4PeNbJpAlSA9Ji4JzARg1V9YFBzucTTBk58U=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RvbP28HP/aJx+ceh6JPKuRzp1kKe70WvvRku2xnmAKDfywEJcOx93JB1PTRmqqZDWnLDBbYJLOl8XGSMzUH8fII8hCB+2KN2fVgvdjE2HPx9Pramza5InFjFf3+Ni7ZzRAZROQ56tjRdGAfE5iD1vYS8xAKz4om7OH1yaxB193U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pO2IctLp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pO2IctLp; arc=fail smtp.client-ip=52.101.83.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pO2IctLp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pO2IctLp"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xRD38noElIDwN7SAbWGPlObRw1c3vP2s1AHdFBSQROaLD7zfV5RFmIQAupHFTfUHaAXz4szF/y1++P4NC8cjlXIi4Me+6XXjCZpmIflVURb8X9I7lzow/Z3oUxwg2+f6gcBB0ZDwSmIz6f9n1JMlX2NGWzCBUMn67VPusE3n436jrzZorTjCEXcv6+C9ZTl+WdO7gDu5WdYYvdprrMrLiLJhz2L8EL3ttw6LStz0zi6iJJeKsdm+o4jorflyFgA86+zLsABsVwd4gTSJ2SG15Qv6SjEK82EJloKA3EA51/0J0ul1FikOCaTJ1z1Dpgqjfh7lQzvh+oSZgM5W3/hpHw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veKIVzF4PeNbJpAlSA9Ji4JzARg1V9YFBzucTTBk58U=;
 b=qFXdEwlhNZ0sYCHso7Wnvii+xno3l7a2qsli2vknh0KvMwV3/tnOwmzpVlA3rMWsvLtZob2Fj8TvhCB3D49Hk8QBXZzN5KK22zKS+Co8GrCtoUBaCnaoTCE/avhUBybc3jv3awFpVnyQu3q4PAifJERcDeV7WG/mQmMcXOAKqgqTXsY+08p2V7Wx3Hm0hdzEuqTuTYiYlnCTg09Bx0N9Sq05Yy0+qb18xJ4wb3xAbiaRVwL6Um/nh/prxBzvqX8RXbLRfZJEto6N/RGhN3vPcXYwLQKBv9OjUT53h/GW2PzZ+391MsdYrNnbw0ywkBIWXdzUqgz3sCaGPRRxEvHvgg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=marvell.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veKIVzF4PeNbJpAlSA9Ji4JzARg1V9YFBzucTTBk58U=;
 b=pO2IctLpb1Jva4RM69DqsZDI7zyFJ4MAUFkcOG2VZs+E8v3Q3Hqq8Kbt2fq9Ms2U42GG8GJOJP9vjFz8Ek7nMgk2PnAU2nkjE0DTeCoLCHuk3g/iMP9mfwE6TEX0JSqSkuaTQLjrxbwSZck+r5J9N6/Ml4grfkJNhQK+1uPiALc=
Received: from AM0PR02CA0172.eurprd02.prod.outlook.com (2603:10a6:20b:28e::9)
 by VI0PR08MB11451.eurprd08.prod.outlook.com (2603:10a6:800:2fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Wed, 18 Mar
 2026 09:54:03 +0000
Received: from AM2PEPF0001C715.eurprd05.prod.outlook.com
 (2603:10a6:20b:28e:cafe::89) by AM0PR02CA0172.outlook.office365.com
 (2603:10a6:20b:28e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Wed,
 18 Mar 2026 09:53:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C715.mail.protection.outlook.com (10.167.16.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Wed, 18 Mar 2026 09:54:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gli7hb1N1VK//ffx0XZ8bNH5pwQHnUlNvuLu2K54w5oR+NkFirTkLKBhbp/fMULvZJzSCZeRTaVgejPDUrWbExzDTMqqI320W9JSHBEdiULnypBJRK5C72JYQ04oC755tHxath7YT5kJTtIR3L/0b8kv/EbPrNb0IF/CdixXxcl6Ei/ZPiYGCr3Fug1iQL3+x8pvyBBcEOfcUaojYM55pB0Gmbp405qVtEhTIm+d5b1mAFVFyr5tzKlod5wxT+SQ9PkTN4EvVLiZ+MN7QKwOM+unZlRRdW9I5KBnfDzo2PBtfhVMwjOA5ZNcqZStXfYdzZ69BmdDn3OqH06qaoXJpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veKIVzF4PeNbJpAlSA9Ji4JzARg1V9YFBzucTTBk58U=;
 b=Ua19Jgo9e0EA8f01C1nTAwWeVZioolC4EfMcPYQ4fCnku01CKDAXpZHcq+TPFSPsy/Wzg23flS81xrGSnezlfn1p9SnHCnTMtLixlncBI2sigetcjnDuIo+PONuZPFiT4fw4SeWpaxvhNVYeuvQzI47CIMzH5zOBffXC5x/g+nKZPYm2wPwPb0uVh0kR5gTs6pA9d+rQ5jpoqqZzC5bPxp31EA3UWTstcD18IN0w5yG59OfUxh/HBM40AShJqz7M1clSfzzJbhX3VGiPJ8LpULwySXiMIb6Y6jp4exUm9XOb4FhI+D6lUsxIUyDmD6rm0IqkhPY6D5b+23a/FTVEqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veKIVzF4PeNbJpAlSA9Ji4JzARg1V9YFBzucTTBk58U=;
 b=pO2IctLpb1Jva4RM69DqsZDI7zyFJ4MAUFkcOG2VZs+E8v3Q3Hqq8Kbt2fq9Ms2U42GG8GJOJP9vjFz8Ek7nMgk2PnAU2nkjE0DTeCoLCHuk3g/iMP9mfwE6TEX0JSqSkuaTQLjrxbwSZck+r5J9N6/Ml4grfkJNhQK+1uPiALc=
Received: from GVXPR08MB10497.eurprd08.prod.outlook.com (2603:10a6:150:156::7)
 by DBAPR08MB5640.eurprd08.prod.outlook.com (2603:10a6:10:1a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Wed, 18 Mar
 2026 09:52:59 +0000
Received: from GVXPR08MB10497.eurprd08.prod.outlook.com
 ([fe80::bc3:f58f:8a36:97af]) by GVXPR08MB10497.eurprd08.prod.outlook.com
 ([fe80::bc3:f58f:8a36:97af%6]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 09:52:59 +0000
From: Howard Zhang <Howard.Zhang@arm.com>
To: Ben Horgan <Ben.Horgan@arm.com>, James Morse <James.Morse@arm.com>
CC: "amitsinght@marvell.com" <amitsinght@marvell.com>,
	"baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>, Catalin Marinas
	<Catalin.Marinas@arm.com>, "corbet@lwn.net" <corbet@lwn.net>, Dave Martin
	<Dave.Martin@arm.com>, "david@kernel.org" <david@kernel.org>,
	"dfustini@baylibre.com" <dfustini@baylibre.com>, "fenghuay@nvidia.com"
	<fenghuay@nvidia.com>, "gshan@redhat.com" <gshan@redhat.com>, Joey Gouly
	<Joey.Gouly@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>, "kobak@nvidia.com" <kobak@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "lcherian@marvell.com"
	<lcherian@marvell.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "punit.agrawal@oss.qualcomm.com"
	<punit.agrawal@oss.qualcomm.com>, "quic_jiles@quicinc.com"
	<quic_jiles@quicinc.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, Rohit Mathew <Rohit.Mathew@arm.com>,
	"scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
	"sdonthineni@nvidia.com" <sdonthineni@nvidia.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "tan.shaopeng@fujitsu.com"
	<tan.shaopeng@fujitsu.com>, "will@kernel.org" <will@kernel.org>,
	"xhao@linux.alibaba.com" <xhao@linux.alibaba.com>, "zengheng4@huawei.com"
	<zengheng4@huawei.com>
Subject: Re: [PATCH v5 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Topic: [PATCH v5 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
Thread-Index: AQHctr0AQrH0v4SIIUW/I5hLBguO6w==
Date: Wed, 18 Mar 2026 09:52:59 +0000
Message-ID: <A76F5D3E-4AB1-4418-B250-2ED9DD1BBE56@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GVXPR08MB10497:EE_|DBAPR08MB5640:EE_|AM2PEPF0001C715:EE_|VI0PR08MB11451:EE_
X-MS-Office365-Filtering-Correlation-Id: dbd82946-cbb2-4107-7016-08de84d4491f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 fLYtPyQhm2AsZXuN7OiUWobo5/n1L+E7U5ODUEZMotiHOf7aMtROCdzGNVqG7CWMDHkceKN7Q4IuOfVaRebPj0Rd7JKJmR/wdImFqH8CsQGBSpZ1Nu5ksnqhNcYXHx23a6wOPU7MNbOwZz9LKGmaIAqfqM1RFjhJpcbtwaxNsAp4gFqz0Uy2VCNlfCv+C8zR3a5WiyvRHSoIyn5XfMA/JNYXMNwgIl4lsva7PR+rYwACa8tqTYdKASCbfUuW4lkXs1gjHQIAkv9McJxKja7mr3KtCNIU//kmVynGGZAHruhKRetKG52p9HLT3WyIyMY6O9F4haG+pHmzyy+gt7LEAaU/FB3P8BTRPKU7uSpb4qTV4ADYjcSHV7Gh0hxOBz0pWv3JgdLFyG4BVY17MaeEaro1CmWX+dOldANmbRPEx6kR2+GzNHEk9qXSQHyDlr/X3ttXffo9UvFN5asiNLTKQhtZjGIwY0VmJLhfOKeUKGTzoMDgixnFL0rpKPlgZ1IUUa7/bLHuhPQUMZ+kgEBnErJ/vgcoZ1vLvNzE/74SUIab6vNPszeoKJXmztV4vcvp6JMRL7QilGfUBUMvu8yGFXHV8toxPGrfkkE3WyK7Bug66/hA3w6l8TOZzugcGY5EBNBO+tiTBlG8zC6PH0KbC40SE8ZX12QruQw/0vbFHVnTPNYSLTH+uDoGSnQDfxeQ3soVN3aa8qXioewOMm1lJmMrBRk68akRd5iCcGcle1CyEK4nuCQdRLyBLA3Zz7mN1uoqz+OB4E7To/RXOJJLg0bOMja3rNbzWYJ9KXRPyJ4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB10497.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C7FB386DE7A2640920CB5B99D0276EF@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 f3YBdjz2n+8sUGXEs1XakAZ17BpF9JjvRwNMd4JeqgJHgtReHoinVMgJy7Fdd3N7N0aFZym8tCmXrTCk2QPAzCEbf5ADtqjb5UIx6PoCAfcJeVQx8QoW4L91JWOCtuxDRBem7HwsC/SQIFvv+YkcNVK7vH1sUBuBoJcSzmIFuZ55+orJ9RANewTWkZzsZ/x0jSvERchpcX+ME4uOnxlqsMcX0B7chCbLVGB2p/DfPDr1uC6o+kJpytrG8xGKlh1C90q9XWjXv13hey5vDKNGUi3WIlb2/9CeKl3P3N6Bi2JHkYu4EMGWj9+N7S6Rd6m075BgVt1aqoSwn8hRuMb9IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5640
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e4cc4a61-a7c9-452f-6b4d-08de84d4232e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|35042699022|376014|1800799024|14060799003|36860700016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	2+RPF0FSg+ZGhYOlebQQu6SbibOWffarxY5wO0Bwuy/n3hB4rENglGv7QyUmETiVOQZy5rkskirEIskKQIFQdDbPKd70AKfU0GIC1BPIspRZcKwtPrvlDMw7QVZyx1vkoKrk2aDwvWgfYJp2Ip6eI4nY8BIoiwgJi+jFmYWPHS99FntYEedqDY8b6U0BacSgRqCbyQkTDqfDkFwm6It5xjW9Unhk4OXF6gLJ/GOM+f6p9euenXAboBeBBWqbN/pfsFN6CXN8jmRTPBrAFIzKtXgbqSkoXSUq7D3rSE+9pC9tVBibNMEkIqkaIkvPOI4SND87xqN/tVz4tILuJh4LyIzl8TaBWvb7uusvyTM9uuRUb6a2qDwYlKYg8PrjMhSEC2rSbxfaovEJiTNHju+byXdk4KFjpZ8sOJFpg9c82dipzOAk2VrKA2sLBLaX956qFYlBVbUGmjrVzE54iMGs7dV6aejZQ48ODlrxMEr1FRQNjmJ1agqPsS7rkdOAbvZaah+Zk4BzVFBsAWKdUs26G2IdZJtB4RZVuXFUBjEcGGK5waRhdiIg3khAXt9YVXVbwUN1evHEiN1cnYI511Bf11V/MhoA47FykWKaVHYwDyF1lYnAG45N4OVvyMMFo7P7awTY5GNdtkWVS0/fNr73svkp9ixOhNNjwbU6l7zzSbDNIxAnU+idUMzjNvBTfe31W6ALl00Q419/UuAzO/0BxOxqBLLa8BhwpN4l4sISogPte/DGQM1YvrBrnQCNdlMmQJc3RlnQjc+1SrnCddvdPg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(35042699022)(376014)(1800799024)(14060799003)(36860700016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XEfX5shn4zKyYfP2HP3HgvRDm6758PFIf4CqsrUxzNyRlgKMalbbm+ya0vCKV+0NL5juV5JHrIU4QN3sI+B8MMMheuEWVv79LjcihDlwGyYtB093TVYFeJEibaIAOpE2UhJWVVxuyLBFv8/L974XRo7o16GgErnmi9u3tPXMPEpHg9uQRLmmRK6Qy3Ja6cDPCrC/t5mxJm/i3acTwSQd9icYFHtRFW0lY0iQo2yVJLhAZBaPH0NujTnU5nRr0NChJC7KxNzNww49KLPG8RBppYUNu1mFMaHN0eKt/01hft+4cveqfl+VFRhWm9DC+pRZr2F5kEtwW+8Ii8hFU4KGmZXlURd+pxoWIhHRToy3LljPaN/5rnz5L35BQvECtHaXr5Je6eDr4qq2hmQGJ9sVVG9par8Pr56J1BB56oltpIF7IVqCFR5xdG7wh0l1mxMv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 09:54:02.6370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd82946-cbb2-4107-7016-08de84d4491f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11451

Hi Ben, James,

I have a few questions regarding MPAM support in the kernel:

Are there any plans to upstream L3 partitioning with capacity-based allocat=
ion (in addition to the existing way-based partitioning)?

Thanks for your time.

Best regards,
Howard=
