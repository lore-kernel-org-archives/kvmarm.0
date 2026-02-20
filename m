Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011046.outbound.protection.outlook.com [40.107.74.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2D4231A21
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 02:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771554665; cv=fail; b=ky7l9FbUuqHRYhfuHd/H7IYcoxiItBcKrnYjtQxWszVYTGBbwrAWD4GP/QI0UsVbUY8QLUQ/QGaZFVz7UlBFn+kMEYSuYIuZEb0zUDyiMJc9gOS6iR5QZ43yQ8HF3RMN/Cuy/qpkBMV2CVQ+ynhscf98dkET5vFvt6T55apHyzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771554665; c=relaxed/simple;
	bh=2Nn2D3mDV6QnjYbC/iz0QrZUc4QKoSr4LbdY0QrhWms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bH8Pv89GSOhD2GiIxPEBGA1zBIAaq2CuPkuBKmW9vFuzG1fh2evQQEbdDoGDyw662XcixNpFUaKAkNajnb/uhMGhbZNDD/X3I7YHCjl/47slTjx8Wu+BjVh76Mb5LG6Qi+cT5SKGQWhsXzq4ynq9C+zU1byW0xQG6X4+n0ht6UA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=UG0FtWyR; arc=fail smtp.client-ip=40.107.74.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="UG0FtWyR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTCGbXoB6rx2aE5MMiltQxNfybaMg+4k2abKZyIYqsC9mL2eO5x5kvafUY/ORI++iYro30Lx9Sbl+LBcmrzqps/fGfCmCD8EXPBGKGj1BmmsP2cL2OiCoH+8ZUOT4gkWzdXoActiCs//pKaB1myA/QE+WDRznRFYKqZz7smnUN02SAL3bmjqmjoVxuFzLQJ2BjsR23nUOROybfNF2UeVIs3YmAEjNUU1LgW0W3PyBPKTmicLZIV31aU59mNOyl9MqjNcupZ8Va92HfPtKrUtV4MWUpDJgs2TNjt+vbKZVEzL2w6FSYZJyZF8MDaeBL+K1Sc/JpjUMma3u9hChl7Nnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Nn2D3mDV6QnjYbC/iz0QrZUc4QKoSr4LbdY0QrhWms=;
 b=JYe/ouZyLDsISON9SeOTTzDJ4wFC5sPM6RD3hWow/2OCE7Cy91WiBnuj+abNFcn1n2A0k9/1AJWXXazYMlxC6aDpbeCcevVubu2GtF8I3yRZU2JmpD4/Dpt+D0mwkJpCw+NPFQGZ8nNfy3qzoiiLfkV4kWMPxVraaljjkgeOR4j96Q05QRMUc3fl0pGJNnUQ79SRAD3UWEkkvJRf2PrccFcpx5oobB92pmVSB9fl8S7Dbrf4yKoZTV2+9Z2HOW+oZyDMcpnYL5NztdF/AxvaJYdo1+0DqKjBNhVEfmSTjZXARlk4Q/wH1GRG+w1Jf+lTHkA8j8bnCzXRzUyXSDe/aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Nn2D3mDV6QnjYbC/iz0QrZUc4QKoSr4LbdY0QrhWms=;
 b=UG0FtWyRON41MCMO2ThFmOfGwOf2FS3b8MJaQ5K3V+TcYHD5y8dOZnjukszdcKb7FJj5CjcwMoqTaURlBe+qTjO0bWQ7INAXl10RIcujv4Vw/NoJJ8Kael+fINLIIOJ3Tw5pXT9P4yLjSz+jhPMdOHdul/O8G3uj5nGCy95wr9iglftpyTe4AdimFOmgL1Borbszq+isq/fL19reos2EH0MiiGE97WVByBwFWJbmRkrO/K6GX1Ctt3H4YXbmFREWOG8RrHb0dN09FidlubRnBKk8duqNXt8HWeY6Kek7FC79SVxdD4/Bkk3MU7LoRmhSNWkeUXfiwWH7d5rRX9zz/Q==
Received: from TY4PR01MB14650.jpnprd01.prod.outlook.com (2603:1096:405:235::5)
 by TY7PR01MB15403.jpnprd01.prod.outlook.com (2603:1096:405:256::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Fri, 20 Feb
 2026 02:31:00 +0000
Received: from TY4PR01MB14650.jpnprd01.prod.outlook.com
 ([fe80::dcf5:1d8a:6a0c:ae2a]) by TY4PR01MB14650.jpnprd01.prod.outlook.com
 ([fe80::dcf5:1d8a:6a0c:ae2a%2]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 02:31:00 +0000
From: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
To: Zeng Heng <zengheng4@huawei.com>, Ben Horgan <ben.horgan@arm.com>
CC: "amitsinght@marvell.com" <amitsinght@marvell.com>,
	"baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
	"dave.martin@arm.com" <dave.martin@arm.com>, "david@kernel.org"
	<david@kernel.org>, "dfustini@baylibre.com" <dfustini@baylibre.com>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "gshan@redhat.com"
	<gshan@redhat.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"kobak@nvidia.com" <kobak@nvidia.com>, "lcherian@marvell.com"
	<lcherian@marvell.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "punit.agrawal@oss.qualcomm.com"
	<punit.agrawal@oss.qualcomm.com>, "quic_jiles@quicinc.com"
	<quic_jiles@quicinc.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
	"scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
	"sdonthineni@nvidia.com" <sdonthineni@nvidia.com>, "xhao@linux.alibaba.com"
	<xhao@linux.alibaba.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v4 38/41] arm_mpam: Add workaround for T241-MPAM-4
Thread-Topic: [PATCH v4 38/41] arm_mpam: Add workaround for T241-MPAM-4
Thread-Index: AQHclVa8w6wA8SC8+EK1Vycko6qcMLWAPTlNgAE6ugCACX8o6w==
Date: Fri, 20 Feb 2026 02:30:59 +0000
Message-ID:
 <TY4PR01MB14650C1796B17A4FC0490EA4A8B68A@TY4PR01MB14650.jpnprd01.prod.outlook.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-39-ben.horgan@arm.com>
 <OSZPR01MB879872E55F0625D737AD06578B61A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
 <f78657e3-7981-ab16-29f7-9daf4de3d42b@huawei.com>
In-Reply-To: <f78657e3-7981-ab16-29f7-9daf4de3d42b@huawei.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-02-20T02:30:59.528Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY4PR01MB14650:EE_|TY7PR01MB15403:EE_
x-ms-office365-filtering-correlation-id: 5adda85b-f0f9-4a82-cb61-08de702815cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?K2hWMHlkSURVNTJsNUNtNUFnZ2ZVTkpNWDJkR1pTVmJUZyt5S3Z2VUJnVWpQ?=
 =?utf-8?B?ME9UaWhFSDc2UW0xZUp3cDJzbWsxNVR2ZXRxRzRsUS9udjZ5azRKRWNGbHJZ?=
 =?utf-8?B?eWNNRk54QmpJMUlhRDdLTi9MM3pXYVliSHBGQlhDL3M2c3crQW9QbWppcWRW?=
 =?utf-8?B?TkVWMFlRaUJ5RlhMeXBEelBzU0wweCtaRmdOalF3c0Q5K2JHcWs3ZkgyL0Yw?=
 =?utf-8?B?U1JWY05OR21xVDRZazhIaGdpZ0w1UDMwQXIvV3g4VVdVdkFycWNndGZ2ZTd4?=
 =?utf-8?B?SGVkaXJhMGYzYThXb05YV0IrVFA1cEY5eHp1VmRtYjJLNkNPa3VIV1Z0b3cr?=
 =?utf-8?B?dUttNEJVOXB4emRjYXQ1aWtwM3B6YkpYakt5Z2hZeitrRGdZZnRRc2RIODVS?=
 =?utf-8?B?MjZjaHd4ME8vWGwrUTQ1T3BxbDRlL1NzZWFsb3owdlo5WnROWlBhNVhjVWF6?=
 =?utf-8?B?aFNUdmhuN0hLMjdFMnNINDFuK09jQ1MrTVU5Skt1SmU2NGVTeVcvblRRNURz?=
 =?utf-8?B?bWdMSERwY3lGMy9kRUJGcGJ1eEJCb2NDdzBzYW5sMk5aQlBYYkkzbGZxWGtM?=
 =?utf-8?B?eGI4NzdOQTkvMlREcDIzNnQ1aitITXZlWG1VK05lZ05OYVRVazkvaHV3bzE1?=
 =?utf-8?B?VXB5TmI3UkZ1bGNnOGIrdGo3aUdUdGhFZzNzU0hTTmNIUmhFMlp6TXVFZExj?=
 =?utf-8?B?ZFI0d0IyTzRzeEdmZWovbktIMTk4QjAyRUU2WUl3bjZTVE1aWTdHYWw5R3Vi?=
 =?utf-8?B?SnQva2ZoaEdrdTNQekt4dmYvY0NwWWpjYkx1Zlg5QXJLT1ZLaTYxL3lRM0l4?=
 =?utf-8?B?TnpPM3JzY0QwWFJBWnFHcC9jbXBDUVlQcmhlNXNyZ2l3NFpxbUhGekg4OERM?=
 =?utf-8?B?cDJMbkE3cGVlamh3d0dGcVYwaWJhUVg2MXFoaTlqYWQ4bFQ4RFgxdEZVa3dJ?=
 =?utf-8?B?a0JSRGVLK2U0Y1I5Tm1BR1FjT0xXNXJmSUppdE0vd2RVOVJBNFBRZFIzaU5I?=
 =?utf-8?B?Rk90VENoR3ROeDBVZXd3VHVXajBVSUFyb2xaYjJ3V3d2dkt4LzI4anFvamp3?=
 =?utf-8?B?eTc0L3ZRRkYzaGU0VzM2NDlQV3ozbHpyT1FPeVFWcTVFL2RSMGxSTUh0NHM1?=
 =?utf-8?B?RXdjMTV0cXl3NS9yNS9EbzVBenNQN3FDZTBQeHBvSVRoU3hjZUhnb0ZKNmlS?=
 =?utf-8?B?d3hPYW1HMXdKZ2lFOTFRd3YxdnhQWExTMzBSUGoyZzdrNnZML09oRzZFWlA2?=
 =?utf-8?B?OUN5N3BaTGkvTVpjc1BSQjhjb1YvU0tQMUIzWitRUlIyc0JsTnBIeU5xMDla?=
 =?utf-8?B?VWs5dXZxUWRIcjVtd3J3d0FJM1Q4RjhJOTFQeERPanhCeWw5Z2U4RHVJTlZE?=
 =?utf-8?B?UDlNcXFQeTNtTUU2d3ZmOEhVTFRWcDQ5dno0WVRQLzNDY3FNM2xoV2FtK2tV?=
 =?utf-8?B?VE1KdnVRQ0RZNmUzcWwxeFIvbkpsOS96REE2WVJ5YlIzTFErNlp5NHN4NWpJ?=
 =?utf-8?B?ZlcwRXI3NnkrN0RMQ0RTYmZsK2pueEVBSXZRN0RBK3dUZUo3blpYMkJSR2Ux?=
 =?utf-8?B?YzdtVWREdjFzaTlHcFVCTDZsSGVoNmNTZU53eEFlUmtoREV5NDhWL241TVdG?=
 =?utf-8?B?UjYxSXZRbnJYbUY0bVI2OGVOMjcxWVZvOGVnb3JsVGxVTmVpVEpnRTBJTVIz?=
 =?utf-8?B?d0xiT0l0VUxnYjN2QXRUWlgvdjVTKzRCQkFYK0N0enZxS1p6eFNzSW84Zmh2?=
 =?utf-8?B?WUQyUUhMczJPK2hwdGNrbzFsZTZNeG9WRWJrYlpuTHRidGZ5OU9UOTd5aTQ4?=
 =?utf-8?B?WkRiTzBWWU1qZU1MdHJIRmVKM2E1eE5jWFBNOVZpOXBVNWZpM3dzSForTEpI?=
 =?utf-8?B?SnI0emFkMVNyckU3eERYWklCV01DNC9ZWUk0UXlvQ1R2WTEwWHlmdEdYRVY5?=
 =?utf-8?B?RXprb2xVOUJsb1pnZFhnQzJsTE9yRjBBNzgrK1M5SzVoUjZyRlM5cWptYzdp?=
 =?utf-8?B?aitGZnVrU0JGOEtxK1JLSkdkMjVmQnJaMUlzS3d1OFJmeUhXVTJYS3EvZ2VD?=
 =?utf-8?B?WlpYVzdXdlB4bS9jZmliZHFRQmJWUk4xQnNIQmR3QnVNUzdXR05YUVpBekhz?=
 =?utf-8?B?N2FmMDdjWUhRVy9HenZQTVd2anp5eThaL0J3YW9WWHNOYmdpdW1YYW1oRGpr?=
 =?utf-8?Q?plxcCaDFvEBy9ozcO0BUu4KXsgQ93ki7HHwuJCqUVYCU?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY4PR01MB14650.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WUpoVEw0cFJHSkpEUXI5L3doek9EMVh4cGdHMG9pYUs0c1U1Q1cyMXo2SlNk?=
 =?utf-8?B?bnArNXNRbk42bW1ZRTh1UXJ2U2lKUEdoOThSZldiRHB3bkk3L1hIWCttbTZS?=
 =?utf-8?B?TXlldEx0KzZLRmJJQjFPNmxmMWFSZmhudE02TGtpYUVONFdndlBWRUc1Rngr?=
 =?utf-8?B?cHZ2cmdPVmVwVDlYajJ0SlFNenI1b1EyMUZ2WlNNT2JmSDZtcWdwNDNTcHRw?=
 =?utf-8?B?ZmRKSHFnL1NIUDZ4bzluRWtXUS9kR0Q5SWcwamNHbmNRL2tKYTBySitjZkYr?=
 =?utf-8?B?by9lY3cvLzZoNzZydXM0QmhUTzVoUDBWdmd0M1JyYVVHZ3QwZENUL0pWNHdi?=
 =?utf-8?B?L0xrdUswdVpSMnVtL29QVUQ0dGM2Q2FvTEtVYjRESDdXWUNqM2hFRllqOU0r?=
 =?utf-8?B?MkNEZFlUU2pLS3RrbE13SkI0dDVEVTRnNGZUNnhnOFM2YkNrL1NhNnQvall0?=
 =?utf-8?B?MHVaR0w5a3BaRHcvR2JEaEIwRDZBc3NITm1ySE1GZ2lKbW83bW5pTEpnZHRq?=
 =?utf-8?B?aGVHdnJNanV6L2R6TVlNQ3hpclkxZDZDV1RvOUl6cFowbER4d1FlVU9xSmpt?=
 =?utf-8?B?Mml6OGZkakFYd3E4Mk0xc0ovQWUxclpuaFA1aVp2dThIVlJhcmlNL1VWTWRU?=
 =?utf-8?B?RWtxMzFsQ21pQVpwT3hhWFZZQ1BMcDZGUW5RNzRTZTRQUmZwMzFrblJhOXY3?=
 =?utf-8?B?c1JNWkNaTE4xUGg4ejNhVmxyYWVsYklPdFpUMEVUcVVRaDdrMzlqUEliOWx1?=
 =?utf-8?B?UUI3aDNWRnlrTFlEOG16ZXdVZFZHMW5Fd3VHUEhPOEYycFB6NHdUc1EyekRz?=
 =?utf-8?B?SUgybldTV3NLREFkQXE2QisyTUxLVnd0cTVFK1FQRGNZMWZhNXJEc1J5NFI2?=
 =?utf-8?B?MnZDTmdzZ2Riejk0SVVlK3NPZXBmT1RzRGlKK3hlY0JUayt2SEpQdVpsMFM5?=
 =?utf-8?B?OUQrWSt0THp2MDVrU1BMVzYrb3ZERG56ZVE3a3hxWGw0OU5vc2V1OGtTdmZ3?=
 =?utf-8?B?R0dNZ05xUVdkVGlZU1B4WjZWTklNRjAzQnlTTmtlMkt1TVdQd21TbmtMclpW?=
 =?utf-8?B?MmhpNGpkWUlTbXpZc3owdFRYUldZSG02WGQxemY3MDNzODE5cys0QjJXU1lD?=
 =?utf-8?B?UzJqQkFMZXBxQnhjY2djY09jdW0vUVR0aDEwa0d1WGJTNGFiSnRlV0l1YlJU?=
 =?utf-8?B?OUlkQUFrZmo1dXBvbThDQXlVa2hOc0JPeldvdzhMV3lEMG1LZEI1Q002SkpX?=
 =?utf-8?B?VDRRUnVLMzB2MTFrUGRtNWlIL2JDYXFyUEhUVXZpdmVUWDNaZXgrMTVWTDBz?=
 =?utf-8?B?OGRJM0FBOVJweDNpVmd6V0t2SlFsZVJ6QnBmR0ZsUnd2K2o5YXhUMUI0ZlFD?=
 =?utf-8?B?djROVWRGR1FpbG14Mm5nMkpjRzFRY2Y5Z3lROGp3ZkZOekJkYU5wTnZoanB5?=
 =?utf-8?B?SmY0MVlzWTh4b2NNUStiR0F4Qi9qUE0vclhyYVBRNmJvajJyQW9mYXVWVFBU?=
 =?utf-8?B?OUZVSWxNM01McmZha1VrTGpyOFhjTUplYWJSNXZTNmVoRk50cW52aHIweEFJ?=
 =?utf-8?B?aE1rVGJzTlVtWlNldlNjTTR5Y0NGYURIWUVKUVUvUXlSbTNCNGZJMThEMjRQ?=
 =?utf-8?B?OExwL05VNlllVk5YcXZOdDFMaCs3akFUL2x4V3RVR3d0Y1VrZVY4Q3VQZlY1?=
 =?utf-8?B?bXpwMlljd1d4a0dRUTFkTVk2OVBkNk0vZ3FIZkhEMmo4ZzZTMFc2ckVvY01H?=
 =?utf-8?B?UU1yOUtDWUpKdjZsNHg2OThGYzdUbmtJUlNJVm5NNmthMWJlQStUODlSN0px?=
 =?utf-8?B?QjMwSXhpUkdTUThrNW5XMitXdHVrOXpDb3VOSEtXWllpVUN0S0VQUVl4azVO?=
 =?utf-8?B?bDBTemdvSi9yS0h6NjRQLzFiNmYwTXZwWHFDNFl0U2lVdzZvTmo0elREZ3Rt?=
 =?utf-8?B?QTZQWTJFWjN1aEpEOENwZVQ4dEpxNUZyRS9WOW1CVndwQWtmMXc5OEVPZ1RV?=
 =?utf-8?B?OUxjWHFLem9INlFsMUhHRmEvVVQ5OHNNOVVCMERXWS9xYnhpR1RWUzEvTllY?=
 =?utf-8?B?WDhPOGRRVGY5TnlPL1dTK1E5OG5CWURCUCtzOGRwY1pYNGlsSTg3cytFZ3VW?=
 =?utf-8?B?RThYbDJULzEvV0h0OEdLa0tRZ0lSNTlaQWN1V2VLakMvRGN5TFU5ZTRLK2dy?=
 =?utf-8?B?MkRZb1Bhb3VOTEprb0Y2dzB2emNGVmtVWTNxa0VBRnpERlNSVjgycXI2UjNk?=
 =?utf-8?B?Q2I0NnhFL2pWbmN5VzY2VmNhdFU2SkJmZExaQjJuYXFPdkVSM0o5cHVHRTRD?=
 =?utf-8?B?REtjMzVSaDgxbHk0a0NqL042ZHZweFFRUHlCdW5Ta1B6eUpkanhqdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY4PR01MB14650.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5adda85b-f0f9-4a82-cb61-08de702815cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2026 02:30:59.9691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +QaYsxxnjGzGiZv4Lh6owl7bfe4KxHX5b7OPsh5tMSNFHpb8WocEq9Ydox9xtC62hy6aA/PtdfrDh4XIxLMirZ1DU3oppXYGIMddzCF8K4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY7PR01MB15403

SGkgWmVuZ2hlbmcKCj4gVGFuLCBTaGFvcGVuZy/orZog57S56bWsO+KAi0JlbiBIb3JnYW4gPGJl
bi5ob3JnYW5AYXJtLmNvbT7igIsKPiDigIthbWl0c2luZ2h0QG1hcnZlbGwuY29tO+KAi2JhaXNo
ZW5nLmdhb0B1bmlzb2MuY29tO+KAi2Jhb2xpbi53YW5nQGxpbnV4LmFsaWJhYmEuY29tO+KAi2Nh
cmxAb3MuYW1wZXJlY29tcHV0aW5nLmNvbTvigItkYXZlLm1hcnRpbkBhcm0uY29tO+KAi2Rhdmlk
QGtlcm5lbC5vcmc74oCLZGZ1c3RpbmlAYmF5bGlicmUuY29tO+KAi2ZlbmdodWF5QG52aWRpYS5j
b2074oCLZ3NoYW5AcmVkaGF0LmNvbTvigItqYW1lcy5tb3JzZUBhcm0uY29tO+KAi2pvbmF0aGFu
LmNhbWVyb25AaHVhd2VpLmNvbTvigItrb2Jha0BudmlkaWEuY29tO+KAi2xjaGVyaWFuQG1hcnZl
bGwuY29tO+KAi2xpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzvigItsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnO+KAi+S7liArMTgg5Lu24oCL4oCL4oCL4oCL4oCLCj4gSGkg
U2hhb3BlbmcsCj4gCj4gT24gMjAyNi8yLzEzIDE1OjAyLCBTaGFvcGVuZyBUYW4gKEZ1aml0c3Up
IHdyb3RlOgo+ID4gSGVsbG8gQmVuLCBGZW5naHVhCj4gPgo+ID4+IEZyb206IFNoYW5rZXIgRG9u
dGhpbmVuaSA8c2RvbnRoaW5lbmlAbnZpZGlhLmNvbT4KPiA+Pgo+ID4+IEluIHRoZSBUMjQxIGlt
cGxlbWVudGF0aW9uIG9mIG1lbW9yeS1iYW5kd2lkdGggcGFydGl0aW9uaW5nLCBpbiB0aGUgYWJz
ZW5jZQo+ID4+IG9mIGNvbnRlbnRpb24gZm9yIGJhbmR3aWR0aCwgdGhlIG1pbmltdW0gYmFuZHdp
ZHRoIHNldHRpbmcgY2FuIGFmZmVjdCB0aGUKPiA+PiBhbW91bnQgb2YgYWNoaWV2ZWQgYmFuZHdp
ZHRoLiBTcGVjaWZpY2FsbHksIHRoZSBhY2hpZXZlZCBiYW5kd2lkdGggaW4gdGhlCj4gPj4gYWJz
ZW5jZSBvZiBjb250ZW50aW9uIGNhbiBzZXR0bGUgdG8gYW55IHZhbHVlIGJldHdlZW4gdGhlIHZh
bHVlcyBvZgo+ID4+IE1QQU1DRkdfTUJXX01JTiBhbmQgTVBBTUNGR19NQldfTUFYLiAgQWxzbywg
aWYgTVBBTUNGR19NQldfTUlOIGlzIHNldAo+ID4+IHplcm8gKGJlbG93IDAuNzgxMjUlKSwgb25j
ZSBhIGNvcmUgZW50ZXJzIGEgdGhyb3R0bGVkIHN0YXRlLCBpdCB3aWxsIG5ldmVyCj4gPj4gbGVh
dmUgdGhhdCBzdGF0ZS4KPiA+Pgo+ID4+IFRoZSBmaXJzdCBpc3N1ZSBpcyBub3QgYSBjb25jZXJu
IGlmIHRoZSBNUEFNIHNvZnR3YXJlIGFsbG93cyB0byBwcm9ncmFtCj4gPj4gTVBBTUNGR19NQldf
TUlOIHRocm91Z2ggdGhlIHN5c2ZzIGludGVyZmFjZS4gVGhpcyBwYXRjaCBlbnN1cmVzIHByb2dy
YW0KPiA+PiBNQldfTUlOPTEgKDAuNzgxMjUlKSB3aGVuZXZlciBNUEFNQ0ZHX01CV19NSU49MCBp
cyBwcm9ncmFtbWVkLgo+ID4+Cj4gPj4gSW4gdGhlIHNjZW5hcmlvIHdoZXJlIHRoZSByZXNjdHJs
IGRvZXNuJ3Qgc3VwcG9ydCB0aGUgTUJXX01JTiBpbnRlcmZhY2UgdmlhCj4gPj4gc3lzZnMsIHRv
IGFjaGlldmUgYmFuZHdpZHRoIGNsb3NlciB0byBNQldfTUFYIGluIHRoZSBhYnNlbmNlIG9mIGNv
bnRlbnRpb24sCj4gPj4gc29mdHdhcmUgc2hvdWxkIGNvbmZpZ3VyZSBhIHJlbGF0aXZlbHkgbmFy
cm93IGdhcCBiZXR3ZWVuIE1CV19NSU4gYW5kCj4gPj4gTUJXX01BWC4gVGhlIHJlY29tbWVuZGF0
aW9uIGlzIHRvIHVzZSBhIDUlIGdhcCB0byBtaXRpZ2F0ZSB0aGUgcHJvYmxlbS4KPiA+Cj4gPiBJ
IGhhdmUgYSBxdWVzdGlvbiByZWdhcmRpbmcgdGhlIE1CV19NSU4gdmFsdWVzLgo+ID4gQXJlIHRo
ZXJlIGFueSBjYXNlcyB3aGVyZSB0aGUgc3VtIG9mIGFsbCBNQldfTUlOIHZhbHVlcyBmcm9tIGRp
ZmZlcmVudCBjb250cm9sIGdyb3VwcyBleGNlZWRzIDEwMCU/Cj4gPiBBbmQgaWYgc28sIGlzIGl0
IGFjY2VwdGFibGUgZm9yIGl0IHRvIGV4Y2VlZCAxMDAlPyIKPiA+Cj4gPiBCZXN0IHJlZ2FyZHMs
Cj4gPiBTaGFvcGVuZyBUQU4KPiA+Cj4gCj4gCj4gUGVyIHRoZSBBUk0gTVBBTSBhcmNoaXRlY3R1
cmUgc3BlY2lmaWNhdGlvbjogIkEgUEFSVElEIHRoYXQgaGFzIHVzZWQKPiBsZXNzIHRoYW4gTUlO
IGlzIGdpdmVuIHByZWZlcmVudGlhbCBhY2Nlc3MgdG8gYmFuZHdpZHRoLiIKPiAKPiBNQldfTUlO
IGlzIG5vdCBhIGd1YXJhbnRlZWQgYmFuZHdpZHRoIGFsbG9jYXRpb24uIEluc3RlYWQsIGl0IHNl
cnZlcyBhcwo+IGEgcHJpb3JpdHkgdGhyZXNob2xkOiB3aGVuIGEgcGFydGlkJ3MgbWVtb3J5IGJh
bmR3aWR0aCB1c2FnZSBmYWxscyBiZWxvdwo+IHRoZSBjb25maWd1cmVkIE1CV19NSU4gdmFsdWUs
IGl0cyBwcmlvcml0eSBmb3IgbWVtb3J5IGJhbmR3aWR0aCBhY2Nlc3MKPiBpcyBlbGV2YXRlZC4K
PiAKPiBUaGVyZWZvcmUsIGl0IGlzIGFjY2VwdGFibGUgZm9yIHRoZSBzdW0gb2YgTUJXX01JTiB2
YWx1ZXMgYWNyb3NzCj4gZGlmZmVyZW50IGNvbnRyb2wgZ3JvdXBzIHRvIGV4Y2VlZCAxMDAlLiBU
aGVyZSBpcyBubyByZXF1aXJlbWVudAo+IGZvciB0aGVzZSB2YWx1ZXMgdG8gYWRkIHVwIHRvIDEw
MCUgb3IgbGVzcy4KPiAKPiBIb3BlIHRoaXMgY2xhcmlmaWVzIHRoZSBiZWhhdmlvci4KCkkgc2Vl
LCB0aGFuayB5b3UuCgpCZXN0IHJlZ2FyZHMsClNoYW9wZW5nIFRBTgo=
