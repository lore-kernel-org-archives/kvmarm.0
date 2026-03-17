Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013026.outbound.protection.outlook.com [40.107.159.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F46C366050
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748066; cv=fail; b=o4nDjZOoDkt+6wX3mxcSnycC1ih8jKDmoR7n310AwpA1Ezh0ACfzD2HC0n4YgcHk2UCuQ6VDCdMItxg6Wzij0VwRRqoWqE5g8KDdfUhtMq2YZdkvpWNb7Mv3burxeyu8vjDvNu7XnORWJ+fanS0EQbFxWCb7WqYrf7UdvKFVdhg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748066; c=relaxed/simple;
	bh=dh1LgAnYj5q3MRL3Bg8Q0N4jM/Jz9QCA4fDjvYFtCac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZQp3XGuergVnYSvk8q2OB4bgdHavb0k21YH0gd3TEL8z1T9eyh7BUlSOnQeLWs0l6w8nw3cTZ38CWVM3oP8aP19SgUitQQx/2rPXlQH8yv46rBMzNgPyTeAS8EyXOw00fpSN+zG36Y7f05YsXku0NhUK0fT+XzQA/9VmpsP4/qs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i1Ua01+z; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i1Ua01+z; arc=fail smtp.client-ip=40.107.159.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i1Ua01+z";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i1Ua01+z"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JwH9D7WFSnHLSLlffQS9lY/NjsRxagU2Cd2ngaj65xMqm5M46hj5wjWirDRZ8Q2FQCqS3C89q3kBGXDTwRZaBTgQAwZNJsZPFMbnjVPs5ZN17Shl7IICv9xnQ91MulUVSzMxOkVseF7T4pct8T3nbj4sdsAXbx2EjVL9M1+4shY/2K69woRSuVqDld35fFLkXX2uGb6T6jnU+v8YDOhUQ5IKISJgH7rrWc482YDo6COKsyLRKNS14ian3XXt30ykyYwxeP4E69eB6hN/m1xdocCohX9W5Cw3a2uwSwJSwMOpHUwTgBO619T5wdqq5bydw9vuMKzdxF/WW6WhN5zejQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQgmp3iTk5lnqZOW/Df8u5L5pqxO0qjK4na4hR9SjSo=;
 b=RAkr6vbUzckfDf4XZcLqlssb57atTeYj7e7K5FjzUYHT1h77ekjHy+QZch8T8N2DxyeJ9Y6OfRnrBdOuTmfPsVFXSU5zNBrBD+NDDLilrCbUmPSO8/Nb/eof/vIVlHupxGgu/MGvubv5vHJ+xexC4rkTX80rKiTBP/8vl8gIpOEzMs351oP0EYaKY/nDoFmV8u4Sjtpg1axMFy4l4qjsg108uw0+fmkw1CL3RopAX4Zo+cQNQVGCDvpQChXPzXgXWM4Xy+XBU+8F4KNVg9S4/wLtWF+qyE7Jf78w9TfBULdWe4tmQUkkRoCovX8IyFUMDi0eys+rhwu5zjr74Awx/Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQgmp3iTk5lnqZOW/Df8u5L5pqxO0qjK4na4hR9SjSo=;
 b=i1Ua01+zze7ApwXXtsOjn97yeN+9XhBUW/MIMYwfTx7njZtD8DyQoQRkBIkMgT++Vm7q++iprUiN5Nxp1q1qtoMMGsIKxiAnXs6tqFoTlV4KEKAMMTUS0zzy5GBFpsZV6iwb6sU70QpgZnNajLGE9ALoWgHckjILkHmZ8MO4HyY=
Received: from AM5PR0601CA0060.eurprd06.prod.outlook.com (2603:10a6:206::25)
 by DB3PR08MB8794.eurprd08.prod.outlook.com (2603:10a6:10:435::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:47:32 +0000
Received: from AMS1EPF00000041.eurprd04.prod.outlook.com
 (2603:10a6:206:0:cafe::c0) by AM5PR0601CA0060.outlook.office365.com
 (2603:10a6:206::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:47:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000041.mail.protection.outlook.com (10.167.16.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:47:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y7Koo/FdKq1FuTnENz5LGAyZtrEVhg8G3DajWrmnxsFWOBvwqe0zPLqs4aMjAVrLwovBUfndjfXITAuZyZdsIA8MWYhatKWJQ2t7u6otdbEIPA8WAgfwRIcSfB8Boqw9sxhvlWRxcN+RNOyJ8dyAxkMuru63mUjfpw9Yvtl0i/W8KbKLR5pJAxMDnQAzMVw/Npm9pVsaTbMvAwxTnXVDAkf4nwMNfkM6WzRT8t9uI3M4/iKi1gy2zfb5mcVFP5cQMUNlHcdb3AJQe6KVWcRuNLWsdmPlxTtROpKHuBNPKZG4kriVs80brOiRLeOcckGdJ3uHJOaSjAJ8P9GNGMK1qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQgmp3iTk5lnqZOW/Df8u5L5pqxO0qjK4na4hR9SjSo=;
 b=KQ0XEpSvyRZXwwyBBMPGzvv+WPY4OKP8pVwDYoJfz1avf64csLNrNRCzG86JVPXOkOs3ItNtQbRVxE4Hk0A78WZMcU+120cKEvHVxoennWWocb/SJQEJSyLH0I6pC9ZDH/XC/XZsRte4HQ/KQS+Os2bVFsv8Sj7+vZGBbtJsng5p+tdHXJ6WKxz0XLb91AkkvCganZUdCwPik2mspBzs1as6XA6BRKgzwXhWJXjXs9NFr5c9ZlUgGFL68Ax78g2l8nih4Mxtj9NXUbH3qqxvH1SrQHXlpiEVdE9CeLZtrlc2+1oL2V3Byu13IcHx85legqbzQGQH/kQLpe5rg/YBwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQgmp3iTk5lnqZOW/Df8u5L5pqxO0qjK4na4hR9SjSo=;
 b=i1Ua01+zze7ApwXXtsOjn97yeN+9XhBUW/MIMYwfTx7njZtD8DyQoQRkBIkMgT++Vm7q++iprUiN5Nxp1q1qtoMMGsIKxiAnXs6tqFoTlV4KEKAMMTUS0zzy5GBFpsZV6iwb6sU70QpgZnNajLGE9ALoWgHckjILkHmZ8MO4HyY=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:46:28 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:46:28 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 25/39] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Topic: [PATCH v6 25/39] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Thread-Index: AQHctgOwcTd2/ntA1EyEWx0vQygl1g==
Date: Tue, 17 Mar 2026 11:46:27 +0000
Message-ID: <20260317113949.2548118-26-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|AMS1EPF00000041:EE_|DB3PR08MB8794:EE_
X-MS-Office365-Filtering-Correlation-Id: a54777a5-5b26-4f32-a136-08de841af93d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 s8xOWYBhfcCuii16bscbUjBwqyP3U5xf7B3WSsC563EIgXUsAKj9a17GUFpXczmTzBWLSIEL1WJ9xw3+XOokUYWwEtEkhrvBbtfUaAhGZN4eg6vLoDFp4eKZQT14OeQ8lWPIpFyI5SvDiXdSpeyVX/zWhPa92zJigaxjOZtU7/SbEe5JI8UNFZTobP++plOP+C8/gC/5UPgvpv5FOuU5+LNahyIfb002B7FzDDReivdeqxkCInp47lfeBiNO00bOZsoaqSfGDJxBO2NHChro7JlHqoRJpNQdbJ1KUX9bLkaaPBbmWfoc8c4AghiSkq0qJs96vxUf80Rkmri0twhWUiL53rKfDHuX6mBqR4vfY3GRUYVReNRvwaal4LoSmDjnQ1nrGxbZzRgFMFiHwMws0DscxIrgUJylfRsAK70AlSQDvfsM1pe9fzqeX1QcxD6xrPgaIhoeZPCrT/VBXJB1P0fzNylNsdbRmGQUWG5XvNLj/2auhxZfzPB9Fleohz4QBaCjOmgZFMZSJx3o7vjwp0pJXLaf/BM0gBFVAkwNxGN3Pv0ZofTbO1l50f977Doz4wi43Rvg2l87MeMHPDjs50LZqKJPv4Pe5ZmFtRPB/DRIcPIvE6nkLjDhcOyV8TWVeoUKWlP9NGXMiVMPiSApXnetVIaH2u3vLppR2MEgoEqqGQZEGlDMB3t+yo2zeKoMUlW19131H3v+xf1dsZwlvVYZ3A/Wm7sujfKVhvNirthvZVo40zJwGG9pM7QPtaMREgcLpfK22+sA8jIt7R2Oy6bGZ6nycR6RcLVi414OHu8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 u3uJrAQB4rIM1ZHNoMi0m38WpYTOkhfcExeZmcgNWrYXc4GtpKOstcl0WpIAL+Orsw4yOAB9Xarw4Wom35AOmpGi5RmRcDeH4MxsEQbB42+to5EXMo+YuIJ3CTdo2qQrBEQGNoCFhL3//qYn+XT+BxNiCN+vkhx0IQ40vqBblqolNjld1pWdC3ij3KbtucS2Agte7QQ/39a7xQUsYrwvoFazGiODJb6De9PgCRuZHRvd/gtCQFQ0KzNng3pmifnbpeXEKAR4AgGk5JIZEj7Dd9OtvekW4ef3ZpURLgb+zcbI2aVTHUTFr1LVCzHT3QEZXQwS7SI3GS6ooqaRuja8Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000041.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b4bff062-612f-4c23-9111-08de841ad329
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700016|35042699022|82310400026|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4tf3LcFuKHJr1wfmVIDsRjXqj6JevO0WfCpt0CgXcQu+at4GgRB30idTK/c0AIFvA/czI+I+dIJQNlwAypeXez22TfRWP+AccNyfiQlBeNDRebKs3nOXDhju6vogqWZvjnZQceyk7XJR606GfTGvazfofVcYSNiSGgGnc9jlbB+VfgA1CK7znqwLLfZXJ7nluJ7CWB9EbvnGY/Sm+Cj3sH7xFo73RTDUJUpSDrwBKdkvxm2AjrX6YfLG3DjT4LLz9iAtPo3qN+dNHsmLkgq8TbKM+LgVIaGtT97U2qaIlbLSkrLYtUULynfGOnW2OpuO1y8nIutSTo0PVHCFZrscFITgJJGk13uRwPVt0oJvHP11SGwAgrKBAFB692kK7nwKi0rWtmj8FfWVhlwv/COpCBSYLHKbSvLLxTgg5cXnAzWeOJcyQPSj2Dj2bRLDZnPorQL3YTZxA7qy/NvshHbt8RkAPA/KobU8oI55n2RFFK5WlOt77Gpu+uQoMTxuiBWRc2WqGa1tKxcCS9syXk2uqEJbNEEjKAI2q4HczknB0hAZNcA/tf4wkoT17w6egmOMTNgxw39H4FevqsZ5dWZT25JaEsTKchZvgcL1zNtEP7rdOkzqLKT9T7fmaMkKowi4RvWuwhJyfBQpFfhuu3+AMVGgrVb/99r9GIH1IMvszRvEwbyCArZAOVb2GUq4NRmximDrhBMYOZYV2W8FAuCZL4elZkaJtx6uUI2oKR0KgR//G4heUDnAlFhfNMADPIELcQqPOuImSadRlUyXxWf1dg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700016)(35042699022)(82310400026)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/7MNIfSee6qe3+UNyS82Xd1SkLU9BuurQ40XM4+eXMW1JbtQEvY6Z8KbCbFyxmOhzFNNB+fQ8tolPbvN+bw/OqHuZV5tRdiJkpGtba+53lPFi17crW2xQy7ydg78mzPabTXLGeGEqGQEC1R3D0LXKXi9ry50tAvYOgYsXmiRK4uOvjlBPau6YgIE7knZFqWb5NQJ1mq6AwN0oVAxPM5xMNCqLaqKybo6bCo91R6rag74bHlRvf3D/ikhPChXj02Vqe+v0PN7EaNY3YZycHCc+DMuClRxsoEfFc3AxS7zbzVFovSj+UgcGTOvMb7Rji+n8+z/hfd9xWFAvuaZVuj6/B2nMgpq6pEfoVQU1EokfX2ov8p/8fuReeEuIM+W9JHAz8yaFITsmE0CEHBAcsobKoRCDcg5j4wZa9WYmAdR2peDIIsrLl6gm3XlNOdbh5L8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:47:31.7807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a54777a5-5b26-4f32-a136-08de841af93d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000041.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8794

GICv5 is able to directly inject PPI pending state into a guest using
a mechanism called DVI whereby the pending bit for a paticular PPI is
driven directly by the physically-connected hardware. This mechanism
itself doesn't allow for any ID translation, so the host interrupt is
directly mapped into a guest with the same interrupt ID.

When mapping a virtual interrupt to a physical interrupt via
kvm_vgic_map_irq for a GICv5 guest, check if the interrupt itself is a
PPI or not. If it is, and the host's interrupt ID matches that used
for the guest DVI is enabled, and the interrupt itself is marked as
directly_injected.

When the interrupt is unmapped again, this process is reversed, and
DVI is disabled for the interrupt again.

Note: the expectation is that a directly injected PPI is disabled on
the host while the guest state is loaded. The reason is that although
DVI is enabled to drive the guest's pending state directly, the host
pending state also remains driven. In order to avoid the same PPI
firing on both the host and the guest, the host's interrupt must be
disabled (masked). This is left up to the code that owns the device
generating the PPI as this needs to be handled on a per-VM basis. One
VM might use DVI, while another might not, in which case the physical
PPI should be enabled for the latter.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 14dba634f79b4..602a970118496 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -180,8 +180,24 @@ static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *k=
vm, struct vgic_irq *irq,
 	return false;
 }
=20
+/*
+ * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
+ */
+static void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *ir=
q,
+				bool dvi)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 ppi;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	ppi =3D vgic_v5_get_hwirq_id(irq->intid);
+	__assign_bit(ppi, cpu_if->vgic_ppi_dvir, dvi);
+}
+
 static struct irq_ops vgic_v5_ppi_irq_ops =3D {
 	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+	.set_direct_injection =3D vgic_v5_set_ppi_dvi,
 };
=20
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
--=20
2.34.1
