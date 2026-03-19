Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013060.outbound.protection.outlook.com [52.101.83.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC002472A6
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929047; cv=fail; b=gM3F+Z4PdnFwWcA9I4EUeM46+zNdomIV+4NLKoiQSVsFbwVX6DHIpDnhaAiSf1jqsxdzZM37A1vW39jcN/MNvtINQ6CWQFLr88kGGSBHV0JMvB/nJYbzOvHenBdRFHTf7ssIIem2NluiLFps+Hw0isaiOP1+THoFLygADFnpovY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929047; c=relaxed/simple;
	bh=3VNOIkplZ/8tmgQp9ou5okvbL22Wo4UXBMac/9Vqvf0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p3McvThA0/EnU/uLFovw7Zg9kmOTLtGTDgwiRPnfoObEQLwxEcXeKJ6qMn7L0EHbz4EqOOCugPGsR6XGb5Cf/nPlOumu9qXhNjuItHryG762/qG9+YrpCg9q5k95sunnO42AIViiI5SPvi7XGwpgcejfSOImHxfZI0XMcjjINt0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qhpFRDmI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qhpFRDmI; arc=fail smtp.client-ip=52.101.83.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qhpFRDmI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qhpFRDmI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wKkWGSgjx47s6ytId9scyveHYqUUJXgNWnpFlnpmBY3TiYU1TiwGuzGnMtDSW/1rAY2NAvrV8KP/C6YNgQ+lUGS577MkurvV69kSLz4BEPVy6Tq06fPY9mEPpsmwVuWBgFJs/VyLEY9kUMHxorHVyudWHmnP6hfynImcxUHA4bp79NJNt5sGkC/RvEmIqh+/UfFD3UlS3bkSid0j1vW74I1UUsT1xXU3SQLyeJ+yXWMbYLQXjv5e6nee4kFX5gmwDai/YPn2AF5S08PumDBOdSwu8i7lY0zTgxQ5cbvmITulmtqQh+kIByc3J4EsbR89M1PaTIHT2CyDusepxokSpA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VNOIkplZ/8tmgQp9ou5okvbL22Wo4UXBMac/9Vqvf0=;
 b=v9IBUzkMc5GksGhhzM+ndeqflBA5rBFzYYbluuy1oJn7dGp0UzHJ7ZCxg4j43YWv/VTSl+5mU9/c7/qL2XSXB6Dq3v9TN5mesx4fk6kIYitjsJWp4Bm4mFDCzisrQpnjg/Q1s7NfZ9rM+gXW1AgJKPyZEEAUbIym24+V6zjc8Zm8iHbTEBOKIFY4nPZTcUWgkfzNAa9mI9wsRfnK3J0TfX/gaRsQbD79atJ613Mq/GtE8EjuUym7HfuM6fRXuzH8xdhL2MHy/xELRk4nh4bqQ7MJs9pjB4i3ZX1aO/9hSR80Z/j4g9XqXpvu6tpEQfaGWKV9c+R71MMel/V20paJJQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VNOIkplZ/8tmgQp9ou5okvbL22Wo4UXBMac/9Vqvf0=;
 b=qhpFRDmI2SP2pE+ohkXUmPe2Crrk+91T31MYCB7Oo2JdW+Psh7bxkaOKvYfGgbgjqSuL915YS86iUKBkbUe35l9SPo1Os/URyh/IcWws6KfPd76hxFihDsEUqJtNjyzbzIuZOBMeSD9UfP2QbhIcCD4gxxO7cmRUppMj3t5lJjc=
Received: from AS4P192CA0015.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5da::10)
 by AS1PR08MB7657.eurprd08.prod.outlook.com (2603:10a6:20b:478::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 14:03:58 +0000
Received: from AM3PEPF0000A78F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5da:cafe::34) by AS4P192CA0015.outlook.office365.com
 (2603:10a6:20b:5da::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 14:03:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78F.mail.protection.outlook.com (10.167.16.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 14:03:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KnWWtCHDkZaYQXG22bzwAiIsDj99J9Cu7MUd6akFKOxwwLGz3tNnST33gMfWx3qLRi30qWssUt0ZOlblI5cFzvmCTiijhwRW7FePuTqbwt7ntljKvr0xUQpK3kTcD2x7NbzxEln0yFnaIXDNWk2mKEV09+2jdCrBWuU0KrF8+aF+qrPK7/qmA15cwpgIYyG66mSJGRtWELLkmfPzyELzHggErZlxpfr1fNksR82PNzJNvKBPv0fir/i/df136dcfmq+stwEweKu7r4EeuaL9Nd3/Do6JI75evNDrSaPFjEtjl0PcX1W8VGuezQfvrwq+SHwWUBqey6fwBcgrSattuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VNOIkplZ/8tmgQp9ou5okvbL22Wo4UXBMac/9Vqvf0=;
 b=Jq66sZhZzuqAbyolPM1RJFbfSmU+aq5l9UIHKGOgKk99X2sv/lhGihkb4A8Kv4u4imQgF9LZTeeUV0poybh837Ogff1xPXzfAlo2o4HF7tvnQKPzxFJnO6G/+NEuQBK55sTYkbg9owsKjrQ+WeQ/iPyTH/WRmsU+jVss1jwx0NVow/omYUROexKrPBfbP9QZTX6gFmnUUPzYR/M3wO6TWhcBw8JghW8Zu580YSE+A6jlp003g6w8sDSIessjfSnc0KfuTJEN5E1lvEwwfkkqeHPw73yoBRcs91Fne9F8Qo0RMhUrM0TBM+Nuoq4dlUdXbAczJwFCUKpVGeCjmWejiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VNOIkplZ/8tmgQp9ou5okvbL22Wo4UXBMac/9Vqvf0=;
 b=qhpFRDmI2SP2pE+ohkXUmPe2Crrk+91T31MYCB7Oo2JdW+Psh7bxkaOKvYfGgbgjqSuL915YS86iUKBkbUe35l9SPo1Os/URyh/IcWws6KfPd76hxFihDsEUqJtNjyzbzIuZOBMeSD9UfP2QbhIcCD4gxxO7cmRUppMj3t5lJjc=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS8PR08MB10194.eurprd08.prod.outlook.com (2603:10a6:20b:63c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 14:02:55 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 14:02:53 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v6 11/39] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v6 11/39] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHctgMtwLROZhoZTESMbIReHqJDA7W1qyuAgAA69QA=
Date: Thu, 19 Mar 2026 14:02:53 +0000
Message-ID: <a9ac3beca3201903878275d05ea17e4940b0eb94.camel@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	 <20260317113949.2548118-12-sascha.bischoff@arm.com>
	 <20260319103151.00006b7e@huawei.com>
In-Reply-To: <20260319103151.00006b7e@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS8PR08MB10194:EE_|AM3PEPF0000A78F:EE_|AS1PR08MB7657:EE_
X-MS-Office365-Filtering-Correlation-Id: cfba7b00-b3f4-407e-274a-08de85c05dae
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 b8oHCRD+BHKQbACWDfhFMXDbph/fL1uUekW9damYvc7ssd4DeAifV19My3M027gFQyAUTBKSiRWfie5Ye/HuQNw/EYCSz5f49+RGMNMMo3VOwJhdSdpocO90zMSgqZEq2vm4AoZs8nS6XffzHfg/yXjqnoZMxNd5lDJcewUWO6dg+OotAi1ywLPqvvQH2yPvsM7tNfHw+Wm0uHm/13h186JzDa1mnPpIiWB9Ax2b2OjT0uOYJ32zdpLzzuQZjxvTrTNxQYcejFv1m4o5gZ5SUgaAayNwc6wD7spPg7jbIjxhNtV79HMweww6JDgwbFD34lUZ6f45PPfRIFSGf06R+saOoNejq4MYEE7gq+YK5heRQ1MzAvi46rUj4CcY/fLVmko9FrJvZ7+PctNahjrZgZu9V8XrkYx2qsoCEIayjDTclL7Hnp/d0LgFhmxxi3oT0FukTyWwNA1BtV0Iti6eUctMUbcgAnGi7cKHGjVvqp0QLjNiWsp5LUKDLyI+jRsk6aI3aZ8DGHV9CUr8oxayeW8btJcy6jqba8vBlu9PfiuUDdsL4lYhF9/LSgwFIfZfYK6IOcPrzDiiPjI21WMA+6K/FAOYsLdQ+YZfLaj6OdUIQMy9f63oq7yuz7anuJF2bsabpcHtcvBDs3GjlqifCW+0ysIPV/xaC2eVLQO1YV2gvPlIgfvmpk7QTnQMe8wRVdRfI7qe1POexZeFfGA8tV67yHVoE1BLUfeIwDneNTyMrtkdvaAuc7mxo+rSLuAWde28v6HnO20Cy+h2hLG5z+tYZxqcJymhloqNkCHjG8E=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <35D188EC5D6BEA4487CF571A91FFF2F0@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 VFTHSCigKp794Pjngjbje6UHwTCn4f/mrfWR6GVcpnQh3N8L25TTw5sGFGsVna4WMPzoBS3mL+5bBpNQo/04bYsC0CmAxhIKOndlLmbOSz5QSDe3Z7/UpMBxyf2AwcpbiQmYX05SAp6NHAgJAfZYPqyP8m8jtMOpFrKAY1Z2WL+nV4s6W1K9imeWTI748sqWfO2KQYZql/Ezl9PUJIzwS0ye5tv5b7ScM3AcXvK8aaeNk2imAbOxtYQXgiY26x0as/QQx9qml+IVgx9OnHCwe6ZZAIoLHuMSMTPif5IWNdC+nEIxKlg5mG1UT+bv0gN6WDRiiR+8EoCyYKSzbT/fCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10194
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	599f08be-78c0-408c-22d1-08de85c03705
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|14060799003|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CPsi1MgnQu7UsyYYDIwZwSmT57KgIaov6JjJOJ3y6l3bKXvny4kDguoux3ziqck/cM15wJ0fpG1Lfdq5nqbVpTi94WD6DY4URdnmlMoLxmeILe7sPww6LNRDXchLjgB3EIiKFl46+OkDhkf20ru4Gj1PWby3TS3FqrsgoNe+pHYd6GfeWNFAWhBwCzpWeZW1uAzeV57kdZgOOhlJs+4qeY2RHv8sFEPQsz6ZAAzJP10NeYJ6G4YjHTS/XoDt+WuJE+3N5VGEUei+l/ujjoFsIs/PN9vtCn1T9i8kh/i+yzBMs+3FQ3SbV0qgGof8nmMJHylMcFmMLQiZLfPWDb8XDXf8uaL7NVm35tbdpJLRdE67RPGA1jzaq4pSXDBZUw0nmZK6CWnSwbIUPyyjeia0ADSd4m2V2t0Tl+hyT+Qs0f3Jm/YHuLr2bUEI6Ugcl1UqkkHWlhEoR+puKlrXsu/yQVb6yeOL8VJ64RUk3CB64zWuE26+rBggz9qDP7L/IfLQhvSKxeZH9p+X9/e91iNSVkggBRst7UypmRIakpLrJZHUksPHIbvfZrgP7IqcXVbfHu16wnPGvDxzAenRDEbLdPgOd7NuykC3/7+6AIeNK8cuS6vBK/WySO8xvD3AuQfgM0upcfFLxp9JjllEMkilnUgALt57FqKxh6kJaq2rQuWYjsSCKiUT84vIiE5R+u1iSUAh+IkOLd0qVPBwFcPtpwBKBNtXscDmRSnGlfzyPfcixz8emY882A1nin7iJKrYtked/hy95xV6F1Y85Ya4mw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(14060799003)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EDu+pZTmdyPN0mxiWjowez9m46SKp+g79U1vA0lNUBcwALThmpywxeYqpQ+XRMEu90M+joukeOk51bKn3YrxCb+awprjLtksenJg7hGD5dbN+T2HqRLbE+1NmZ6jh6BwAMBEzAtrWBk/AVh6QxiUpk4WwaJFO9997HsVaB2t+Q7BX3rF5qcfx6Kl5GT1hK/bsdeXiA5g20X4P/Ls1OiNArOkNBUxyhuL+f4ISb0fRp+HJLjb3Si04/fD9E4AmA3XWHJTMAowujeFpjPC8JQFVKHbQHJk/XkTaaaatEiyF3pTa1XLlOblrYA6J0gf0g1I8sDvUYALGQDtIATeG2uvWuXaLNiG4A8RYIDKGy+bY7+f+4vkCp3yaT3pTqd0ee40XLAlC0V6IbAhCEolAAFJsMk/Sy6pAin/8i9BdBIJqOROsfB0IWpKzCyAPJCpEwP3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 14:03:58.3998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfba7b00-b3f4-407e-274a-08de85c05dae
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7657

T24gVGh1LCAyMDI2LTAzLTE5IGF0IDEwOjMxICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBUdWUsIDE3IE1hciAyMDI2IDExOjQyOjQ3ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBBZGQgaW4gYSBzYW5p
dGl6YXRpb24gZnVuY3Rpb24gZm9yIElEX0FBNjRQRlIyX0VMMSwgcHJlc2VydmluZyB0aGUNCj4g
PiBhbHJlYWR5LXByZXNlbnQgYmVoYXZpb3VyIGZvciB0aGUgRlBNUiwgTVRFRkFSLCBhbmQgTVRF
U1RPUkVPTkxZDQo+ID4gZmllbGRzLiBBZGQgc2FuaXRpc2F0aW9uIGZvciB0aGUgR0NJRSBmaWVs
ZCwgd2hpY2ggaXMgc2V0IHRvIElNUCBpZg0KPiA+IHRoZSBob3N0IHN1cHBvcnRzIGEgR0lDdjUg
Z3Vlc3QgYW5kIE5JLCBvdGhlcndpc2UuDQo+ID4gDQo+ID4gRXh0ZW5kIHRoZSBzYW5pdGlzYXRp
b24gdGhhdCB0YWtlcyBwbGFjZSBpbiBrdm1fdmdpY19jcmVhdGUoKSB0bw0KPiA+IHplcm8NCj4g
PiB0aGUgSURfQUE2NFBGUjIuR0NJRSBmaWVsZCB3aGVuIGEgbm9uLUdJQ3Y1IEdJQyBpcyBjcmVh
dGVkLiBNb3JlDQo+ID4gaW1wb3J0YW50bHksIG1vdmUgdGhpcyBzYW5pdGlzYXRpb24gdG8gYSBz
ZXBhcmF0ZSBmdW5jdGlvbiwNCj4gPiBrdm1fdmdpY19maW5hbGl6ZV9zeXNyZWdzKCksIGFuZCBj
YWxsIGl0IGZyb20NCj4gPiBrdm1fZmluYWxpemVfc3lzX3JlZ3MoKS4NCj4gPiANCj4gPiBXZSBh
cmUgcmVxdWlyZWQgdG8gZmluYWxpemUgdGhlIEdJQyBhbmQgR0NJRSBmaWVsZHMgYSBzZWNvbmQg
dGltZQ0KPiA+IGluDQo+ID4ga3ZtX2ZpbmFsaXplX3N5c19yZWdzKCkgZHVlIHRvIGhvdyBRRU1V
IGJsaW5kbHkgcmVhZHMgb3V0IHRoZW4NCj4gPiB2ZXJiYXRpbSByZXN0b3JlcyB0aGUgc3lzdGVt
IHJlZ2lzdGVyIHN0YXRlLiBUaGlzIGF2b2lkcyB0aGUgaXNzdWUNCj4gPiB3aGVyZSBib3RoIHRo
ZSBHQ0lFIGFuZCBHSUMgZmVhdHVyZXMgYXJlIG1hcmtlZCBhcyBwcmVzZW50IChhbg0KPiA+IGFy
Y2hpdGVjdHVyYWxseSBpbnZhbGlkIGNvbWJpbmF0aW9uKSwgYW5kIGhlbmNlIGd1ZXN0cyBmYWxs
IG92ZXIuDQo+ID4gU2VlDQo+ID4gdGhlIGNvbW1lbnQgaW4ga3ZtX2ZpbmFsaXplX3N5c19yZWdz
KCkgZm9yIG1vcmUgZGV0YWlscy4NCj4gPiANCj4gPiBPdmVyYWxsLCB0aGUgZm9sbG93aW5nIGhh
cHBlbnM6DQo+ID4gDQo+ID4gKiBCZWZvcmUgYW4gaXJxY2hpcCBpcyBjcmVhdGVkLCBGRUFUX0dD
SUUgaXMgcHJlc2VudGVkIGlmIHRoZSBob3N0DQo+ID4gwqAgc3VwcG9ydHMgR0lDdjUtYmFzZWQg
Z3Vlc3RzLg0KPiA+ICogT25jZSBhbiBpcnFjaGlwIGlzIGNyZWF0ZWQsIGFsbCBvdGhlciBzdXBw
b3J0ZWQgaXJxY2hpcHMgYXJlDQo+ID4gaGlkZGVuDQo+ID4gwqAgZnJvbSB0aGUgZ3Vlc3Q7IHN5
c3RlbSByZWdpc3RlciBzdGF0ZSByZWZsZWN0cyB0aGUgZ3Vlc3Qncw0KPiA+IGlycWNoaXAuDQo+
ID4gKiBVc2Vyc3BhY2UgaXMgYWxsb3dlZCB0byBzZXQgaW52YWxpZCBpcnFjaGlwIGZlYXR1cmUg
Y29tYmluYXRpb25zDQo+ID4gaW4NCj4gPiDCoCB0aGUgc3lzdGVtIHJlZ2lzdGVycywgYnV0Li4u
DQo+ID4gKiAuLi5pbnZhbGlkIGNvbWJpbmF0aW9ucyBhcmUgcmVtb3ZlZCBhIHNlY29uZCB0aW1l
IHByaW9yIHRvIHRoZQ0KPiA+IGZpcnN0DQo+ID4gwqAgcnVuIG9mIHRoZSBndWVzdCwgYW5kIHRo
aW5ncyBob3BlZnVsbHkganVzdCB3b3JrLg0KPiA+IA0KPiA+IEFsbCBvZiB0aGlzIGV4dHJhIHdv
cmsgaXMgcmVxdWlyZWQgdG8gbWFrZSBzdXJlIHRoYXQgImxlZ2FjeSIgR0lDdjMNCj4gPiBndWVz
dHMgYmFzZWQgb24gUUVNVSB0cmFuc3BhcmVudGx5IHdvcmsgb24gY29tcGF0aWJsZSBHSUN2NSBo
b3N0cw0KPiA+IHdpdGhvdXQgbW9kaWZpY2F0aW9uLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6
IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLaW5kIG9m
IHRyaXZpYWwgYnV0IEknZCBoYXZlIHNwbGl0IHRoaXMgaW50byBhIGZhY3RvciBvdXQgb2YgdGhl
DQo+IGhlbHBlcg0KPiAobm8gZnVuY3Rpb25hbCBjaGFuZ2VzKSB0aGVuIHRoZSBhZGRpdGlvbmFs
IHN0dWZmLg0KPiBNZWgsIGl0J3Mgc2ltcGxlIGVub3VnaCB0byBwZXJoYXBzIG5vdCBiZSB3b3J0
aCB0aGUgZWZmb3J0Lg0KPiANCj4gQW55aG93LCBvbmUgY29tbWVudCBvbiB3aGF0IHRvIG1lIGxv
b2tzIGxpa2UgYSBzbGlnaHRseSBpbmNvbnNpc3RlbnQNCj4gYXBwcm9hY2gNCj4gdG8gc2FuaXRp
emF0aW9uLiBBbnlob3csIG5vdCB0aGF0IGltcG9ydGFudCBhcyBjb2RlIGlzIGVhc3kgZW5vdWdo
IHRvDQo+IHJlYWQNCj4gYW5kIGlmIGFueXRoaW5nIG92ZXIgcmVzdHJpY3RzICh3aGljaCBjb3Vs
ZCBiZSByZWxheGVkIGlmIHRoYXQgZXZlcg0KPiBiZWNvbWVzDQo+IHJlbGV2YW50KS4NCj4gDQo+
IFJldmlld2VkLWJ5OiBKb25hdGhhbiBDYW1lcm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5j
b20+DQo+IA0KPiANCj4gPiAtLS0NCj4gPiDCoGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmPCoMKg
wqDCoMKgwqAgfCA3MA0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQ0KPiA+
IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYyB8IDQ5ICsrKysrKysrKysrKysrKyst
LS0tLS0tDQo+ID4gwqBpbmNsdWRlL2t2bS9hcm1fdmdpYy5owqDCoMKgwqDCoMKgwqDCoMKgIHzC
oCAxICsNCj4gPiDCoDMgZmlsZXMgY2hhbmdlZCwgOTggaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRp
b25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMg
Yi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jDQo+ID4gaW5kZXggNDJjODRiNzkwMGZmNS4uMTQw
Y2YzNWY0ZWViNCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jDQo+
ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0KPiA+IEBAIC0xNzU4LDYgKzE3NTgs
NyBAQCBzdGF0aWMgdTggcG11dmVyX3RvX3BlcmZtb24odTggcG11dmVyKQ0KPiA+IMKgDQo+ID4g
wqBzdGF0aWMgdTY0IHNhbml0aXNlX2lkX2FhNjRwZnIwX2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsDQo+ID4gdTY0IHZhbCk7DQo+ID4gwqBzdGF0aWMgdTY0IHNhbml0aXNlX2lkX2Fh
NjRwZnIxX2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gdTY0IHZhbCk7DQo+
ID4gK3N0YXRpYyB1NjQgc2FuaXRpc2VfaWRfYWE2NHBmcjJfZWwxKGNvbnN0IHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwNCj4gPiB1NjQgdmFsKTsNCj4gPiDCoHN0YXRpYyB1NjQgc2FuaXRpc2VfaWRf
YWE2NGRmcjBfZWwxKGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiB1NjQgdmFsKTsN
Cj4gPiDCoA0KPiA+IMKgLyogUmVhZCBhIHNhbml0aXNlZCBjcHVmZWF0dXJlIElEIHJlZ2lzdGVy
IGJ5IHN5c19yZWdfZGVzYyAqLw0KPiA+IEBAIC0xNzgzLDEwICsxNzg0LDcgQEAgc3RhdGljIHU2
NCBfX2t2bV9yZWFkX3Nhbml0aXNlZF9pZF9yZWcoY29uc3QNCj4gPiBzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsDQo+ID4gwqAJCXZhbCA9IHNhbml0aXNlX2lkX2FhNjRwZnIxX2VsMSh2Y3B1LCB2YWwp
Ow0KPiA+IMKgCQlicmVhazsNCj4gPiDCoAljYXNlIFNZU19JRF9BQTY0UEZSMl9FTDE6DQo+ID4g
LQkJdmFsICY9IElEX0FBNjRQRlIyX0VMMV9GUE1SIHwNCj4gPiAtCQkJKGt2bV9oYXNfbXRlKHZj
cHUtPmt2bSkgPw0KPiA+IC0JCQkgSURfQUE2NFBGUjJfRUwxX01URUZBUiB8DQo+ID4gSURfQUE2
NFBGUjJfRUwxX01URVNUT1JFT05MWSA6DQo+ID4gLQkJCSAwKTsNCj4gPiArCQl2YWwgPSBzYW5p
dGlzZV9pZF9hYTY0cGZyMl9lbDEodmNwdSwgdmFsKTsNCj4gPiDCoAkJYnJlYWs7DQo+ID4gwqAJ
Y2FzZSBTWVNfSURfQUE2NElTQVIxX0VMMToNCj4gPiDCoAkJaWYgKCF2Y3B1X2hhc19wdHJhdXRo
KHZjcHUpKQ0KPiA+IEBAIC0yMDI3LDYgKzIwMjUsMjMgQEAgc3RhdGljIHU2NCBzYW5pdGlzZV9p
ZF9hYTY0cGZyMV9lbDEoY29uc3QNCj4gPiBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB2YWwp
DQo+ID4gwqAJcmV0dXJuIHZhbDsNCj4gPiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgdTY0IHNh
bml0aXNlX2lkX2FhNjRwZnIyX2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4g
dTY0IHZhbCkNCj4gPiArew0KPiA+ICsJdmFsICY9IElEX0FBNjRQRlIyX0VMMV9GUE1SIHwNCj4g
PiArCcKgwqDCoMKgwqDCoCBJRF9BQTY0UEZSMl9FTDFfTVRFRkFSIHwNCj4gPiArCcKgwqDCoMKg
wqDCoCBJRF9BQTY0UEZSMl9FTDFfTVRFU1RPUkVPTkxZOw0KPiANCj4gU3R5bGUgd2lzZSB0aGlz
IGZlZWxzIGluY29uc2lzdGVudC7CoCBGb3IgdGhlc2UgMyByZWdpc3RlcnMgdGhlDQo+IHNhbml0
aXNlIHNpbXBseQ0KPiBjbGVhcnMgdGhlbSBpZiBub3Qgc3VwcG9ydGVkLCBpdCBkb2Vzbid0IGVu
Zm9yY2UgcGFydGljdWxhciB2YWx1ZXMNCj4gZGVzcGl0ZQ0KPiBmb3IgZXhhbXBsZSBNVEVTVE9S
RU9OTFkgb25seSB0YWtpbmcgdmFsdWVzIDAgYW5kIDEuLg0KPiANCj4gDQo+ID4gKw0KPiA+ICsJ
aWYgKCFrdm1faGFzX210ZSh2Y3B1LT5rdm0pKSB7DQo+ID4gKwkJdmFsICY9IH5JRF9BQTY0UEZS
Ml9FTDFfTVRFRkFSOw0KPiA+ICsJCXZhbCAmPSB+SURfQUE2NFBGUjJfRUwxX01URVNUT1JFT05M
WTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlpZiAodmdpY19ob3N0X2hhc19naWN2NSgpKQ0KPiAN
Cj4gLi5idXQgZm9yIHRoaXMgb25lIHlvdSBhcmUgZm9yY2luZyBhIHNwZWNpZmljIHZhbHVlIHJh
dGhlciB0aGFuDQo+IGNsZWFyaW5nIHdoYXRldmVyDQo+IHdhcyB0aGVyZSBpZiAhdmdpY19ob3N0
X2hhc19naWN2NSgpDQoNClllYWgsIEkgdGhpbmsgaXQgaXMgYSBjb21iaW5hdGlvbiBvZiBtYXRj
aGluZyB0aGUgcHJldmlvdXMgYmVoYXZpb3VyDQood2hpY2ggd2FzIHRvIGxldCB0aG91Z2ggZmll
bGRzIHRocm91Z2ggdmVyYmF0aW0pIGFuZCB3aGF0IGlzIGhhcyBiZWVuDQpkb25lIHByZXZpb3Vz
bHkgZm9yIHRoZSBHSUMgZmllbGQgaW4gdGhlIElEX0FBNjRQRlIwLg0KDQpJIGRvIGFncmVlIHRo
YXQgdGhlIHN0eWxlcyBhcmUgZGlmZmVyZW50LCBidXQgSSBhbSBub3Qgc3VyZSBjaGFuZ2luZw0K
dGhhdCB3aWxsIG1ha2UgdGhpbmdzIGNsZWFyZXIuIEl0IGlzIGdvb2QgdG8gYmUgZXhwbGljaXQg
YWJvdXQgd2hlbg0KRkVBVF9HQ0lFIGlzIHByZXNlbnRlZCBhcyBJTVAgb3Igbm90LCBzbyB3b3Vs
ZCBwcmVmZXIgdG8gbGVhdmUgdGhhdCBhcw0KaXQgaXMuIFRoZSBvdGhlciBjaGVja3Mgd291bGQg
cmVxdWlyZSBzb21ldGhpbmcgbGlrZToNCg0KaWYgKHZhbCAmIElEX0FBNjRQRlIyX0VMMV9NVEVG
QVIpIHsNCgl2YWwgJj0gfklEX0FBNjRQRlIyX0VMMV9NVEVGQVI7DQoJdmFsIHw9IFNZU19GSUVM
RF9QUkVQX0VOVU0oSURfQUE2NFBGUjJfRUwxLCBNVEVGQVIsIElNUCk7DQp9DQoNCkknbSBoYXBw
eSB0byBkbyB0aGlzIGlmIHlvdSBmZWVsIHN0cm9uZ2x5IGVub3VnaCwgYnV0IG90aGVyd2lzZSB3
b3VsZA0KcHJlZmVyIHRvIGxlYXZlIHRoaXMgYXMgaXMgZm9yIG5vdy4NCg0KVGhhbmtzLA0KU2Fz
Y2hhDQoNCj4gDQo+IEkgZG9uJ3QgbWluZCB0aGF0IG11Y2ggdGhvdWdoIGFzIHN0aWxsIG9idmlv
dXMgd2hhdCBpcyBnb2luZyBvbiBhbmQNCj4gcGVyaGFwcw0KPiB3ZSBkbyBuZWVkIHRvIGJlIGNh
cmVmdWwgdGhpcyB0YWtlcyBvbmx5IGEgMSBvciAwLg0KPiANCj4gDQo+ID4gKwkJdmFsIHw9IFNZ
U19GSUVMRF9QUkVQX0VOVU0oSURfQUE2NFBGUjJfRUwxLCBHQ0lFLA0KPiA+IElNUCk7DQo+ID4g
Kw0KPiA+ICsJcmV0dXJuIHZhbDsNCj4gPiArfQ0KPiANCj4gDQoNCg==
