Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011031.outbound.protection.outlook.com [40.107.74.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460444A9D60
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 13:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792155632; cv=fail; b=EWQ84ohEAG0zN/oISUYbBR/F6LRKzTkwPsUR4SmKUmYrdE0EFxPII6gqjJlQLv+lmOp10YeS/dhVpUcA2ippJCCY9Lp3tC+zuLfcJYmF/P9NWJEKWpjrKvoxd/kxIzCWyNiuxoTd7oenZuNPTiVSA0OocAflhQdZjpCitXskRzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792155632; c=relaxed/simple;
	bh=U6cM07bnw982O6l1dzyjG0SrEARlATLHrM9sV5i+FJE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ji7TdnCZgZ2qlPGwlAtFLkX2q2c34exUxdC1Taj3fOw5RSs/YLydPQPUR74WJ4hqzWqGxtlijuYDj1O/RyoBa4cMKH7ZjiGwKRdGDkJe7uvL3ACRQA+lhubDWqpMa8GYJOT3y2kgv2cAxOwgLfndAmBMAMVxY6PCsxIfq4GjZB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=XsDfSYYA; arc=fail smtp.client-ip=40.107.74.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="XsDfSYYA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J7nn6ywz1k6q68qUily/Ah6cLnA7eRg+bjvwO2w+LjMzZ/TvFOfVBGhy2TZsPeprMlM8ZgqLKGJDfkTkF5KJxQVwTU4N3aRnxhtSNTfKhESnOb4ilBY/F4k1RzJvj865h5T4gP2LlK3zLTU/SpL700QytNcB51kHNfgHAjwPl0g5Cm6y4aDPlEuZyUjADpd2ethBqVRLMpzS8Y1QjzLJDxZ/2imvZBn7uPAHPubED3mq4CmukrbfC9CD3UbGrsen30sVAK1O1QOUKRxpTWXPGl7kY/cye0sOaWmuHKdAKMXCdvaXdWoiyOdG6Yhq+SO0fuxFqxfxkQyLibPsWY+JGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1Qq8yTO6ayTcSnpYdPFKlCgpCuwwLG83gU5RMJ4hAA=;
 b=wC5b48GJtW0AJdQSwNuc+wE/6BDVWIP5eR1RX8Kttb8IET6FPrM/Xe4TYIMJjG/tzbDP/pZpnU/T9rwjcyU/h5AsgX4yTtJmT+QacqI/9qHlF83Tls8W6G0KGFUNiZph+UNgNE4E+pt1jowqFdIURIlyhs5zM19uzDRNSGH3ArAx0RZOlCkMb58oMk12Bc+8yMrrvVIj7/EqwEjcaVTtYq6GvJ9TXFwh5aHKr5Cg35RCpXP12mf4J4KsQqf9flGoek+pl301gTIl6VcWGRtuUr1LOcd4wX+kcQQBlmwcaOTUIOd1cRlxSIO68+ZCPIZnd0q3Q/9Aw5qqNbKNMu35Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1Qq8yTO6ayTcSnpYdPFKlCgpCuwwLG83gU5RMJ4hAA=;
 b=XsDfSYYAY8HL2MyqOj3z4xFBmxlyP10RTLuN/kWUtbRHVR1mp2Hs2nCN9bMB6Le6tcQsZpbCYgqfb5ZDiNPyNn4xgW5x1jBCVBSP/OLKnLVsV1jKEYAlXFZzobqeLRNKpqPnKbD8R3DTth34XgS06EoKsgiUuLgxjWknQOwRjuGg+nGv/k0z4QgFl8Uk3XKD5iKuHBPNEqYoNoE8xwbdOwYRaqBKj58mvpdWoK0nwA0MZuCLzqqywIMY8mDNJ4Q2BP387Hek7vYPexXmg65G1SNeaf+AimJlge62xyns/qMlChhqSTPXgh4QdExA6JKKeHmtAuxjwGoqXrWDxN/gnQ==
Received: from OSCPR01MB15739.jpnprd01.prod.outlook.com
 (2603:1096:604:3cb::14) by TYRPR01MB12287.jpnprd01.prod.outlook.com
 (2603:1096:405:ff::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Fri, 16 Oct
 2026 13:00:21 +0000
Received: from OSCPR01MB15739.jpnprd01.prod.outlook.com
 ([fe80::acf8:3415:5b7f:12c0]) by OSCPR01MB15739.jpnprd01.prod.outlook.com
 ([fe80::acf8:3415:5b7f:12c0%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 13:00:20 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Mark Rutland' <mark.rutland@arm.com>
CC: 'Catalin Marinas' <catalin.marinas@arm.com>, 'Will Deacon'
	<will@kernel.org>, 'Jonathan Corbet' <corbet@lwn.net>, 'Shuah Khan'
	<skhan@linuxfoundation.org>, 'Randy Dunlap' <rdunlap@infradead.org>, 'Marc
 Zyngier' <maz@kernel.org>, 'Thomas Gleixner' <tglx@kernel.org>, 'Radu Rendec'
	<radu@rendec.net>, 'Oliver Upton' <oupton@kernel.org>, 'Fuad Tabba'
	<fuad.tabba@linux.dev>, 'Joey Gouly' <joey.gouly@arm.com>, 'Steffen Eiden'
	<seiden@linux.ibm.com>, 'Suzuki K Poulose' <suzuki.poulose@arm.com>, 'Zenghui
 Yu' <yuzenghui@huawei.com>, "Kohei Enju (Fujitsu)" <enju.kohei@fujitsu.com>,
	"'linux-arm-kernel@lists.infradead.org'"
	<linux-arm-kernel@lists.infradead.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, "'linux-doc@vger.kernel.org'"
	<linux-doc@vger.kernel.org>, "'linux-perf-users@vger.kernel.org'"
	<linux-perf-users@vger.kernel.org>, "'kvmarm@lists.linux.dev'"
	<kvmarm@lists.linux.dev>
Subject: RE: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
 Erratum E#030002
Thread-Topic: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
 Erratum E#030002
Thread-Index: AQHdXVVbzJOi/425oUyzsr9T2p9p/LcAE4mAgAADN9A=
Date: Fri, 16 Oct 2026 13:00:13 +0000
Deferred-Delivery: Fri, 16 Oct 2026 12:59:15 +0000
Message-ID:
 <OSCPR01MB1573944ED57DC682897594F06E59B2@OSCPR01MB15739.jpnprd01.prod.outlook.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-3-fc7ede7f9f48@fujitsu.com>
 <atIT0dmeqAXLoThW@J2N7QTR9R3.cambridge.arm.com>
In-Reply-To: <atIT0dmeqAXLoThW@J2N7QTR9R3.cambridge.arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=93366836-92ea-417c-9514-fd1f02ffbe5f;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2026-10-16T12:58:38Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Tag=10,
 0, 1, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSCPR01MB15739:EE_|TYRPR01MB12287:EE_
x-ms-office365-filtering-correlation-id: 0f6b0d57-2cba-42db-3971-08df2b856f42
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|38070700021|56012099006|4143699003|11063799006|5023799004|261009223027099003|10067099003|18002099003|22082099003|6133799003|1580799027;
x-microsoft-antispam-message-info:
 0eskU3ENX5zqO2arnOjRCQx1O7oFpFyNh+Od8M9zVNz9ED2yHZYIQYGw185WQ85kpc+n3r/mX3UtCPc5MQXNk9lUfUoQUHxkfdogtl+AoU28E9aJNrxsID/Jc52AtxxC3t3XsfJ+XGm5BKzZPGeZNu7XP1T+HpnsgzO3iB7xKYw6wdtsXi+HdQYOQf5k5wFF8eTYOObgJaBi9O1Gr/ObINRoAyNpsb8g/OoK3c/Bt2Uo4P/DfpfZFlwGRQLsUZh5tu9GnkZEDiREnFU0D+7Yp5Y5LPHJVKTkUGxT5hEwv/EoK/g8z1qPEwNP5aIuFXESzYM8/Rf9Zwredrrm9jRoz5eXk15h1cJp1zyJkdJGJN7+Wk81SeYpx18cHgFOYcXPLUA42s4yo+eYA1BcKnxoNBxfNCy/3C/kZ/1yY04lN1peHyfT17cR5W+dj6imZbX5HXI1K7gJkxFp7h1Sb1ArT5pfI8qo9JhSzlchbkxXfJA7lpE+KcimMIYLy4s25ETO2QvUz21On41N+ZYv9N4hXsszy5DGbv3/VvUsF17StsSv8OC0vQVIqKOzd5O5vKrkadh322RYiiS5hqxrmihX5jkWeVVxoE7p+7yy799JsDhU+lfiRQuFdUZ/lQKAxpQJbEsVUdZY26fECP3e1z5eqGBFmYg6/wYVaUBaX4wHCpnHmn9MqXNQuWn0JcI6w2GGrEQ7PyCDiLSHz62oJqKLkQrvrl3/qDCJZZjgHlazn+U1Mx51d60VnQKn5r+gSxSg
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSCPR01MB15739.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(38070700021)(56012099006)(4143699003)(11063799006)(5023799004)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?ZDFoM2ExaDdrRmJsSEZjc005RXB6NmJlSWZYWnZXNmNCa25wbUNkcStw?=
 =?iso-2022-jp?B?V213VkszalU3MzYxV3RUZ1NHWFk1SEgzNkU1T2E4R2JEQ0Fxb0RWQWhp?=
 =?iso-2022-jp?B?VXBLbGUrUTVaQmJQWlFMTlNCZkxzV0dBay96Y0U2TFJoQ0FCbC96TkNW?=
 =?iso-2022-jp?B?OXh0bDMyYTZ0MGhCZ01KYlhERzJKUWJSNUNDd0Jqb2FjcWJLTGgyKzRn?=
 =?iso-2022-jp?B?SmFVVnFpZ3pYZmplYlp4Q1dGbHhuSTBodmJxNENCNm1INVQ4ZThJVTFk?=
 =?iso-2022-jp?B?RTdNNlNKMnN0RlR5c0JJclQxUEp0YkRROUh3TFlBZlBFUElXbmRJcGRU?=
 =?iso-2022-jp?B?ZVZCVmltbGRxOFdET0JWMWdOdnY1eGkwSEYra09pTTBkelQ0ZUVQalA4?=
 =?iso-2022-jp?B?Z0xlZE04dE1hamZYcTBDUVBSejk0V01wcGNxQ1J4OTRiWFY1L0Rmenlw?=
 =?iso-2022-jp?B?M3BydUN0WGh4OEtrdFNmMVEvVXRoNlpQVENETWxPWUZLQ3UzV1Y1allx?=
 =?iso-2022-jp?B?VXppbXRiaTVNR2RRY0RmeUh4VU5QRk0wRmxvMUN2eUo0Q1RZelB2WS91?=
 =?iso-2022-jp?B?S1VxaEdyL3QzeXN3d0thZG5ZUklGY0ZnRnJoSUtDdWt5R3dhbDlHZ2hC?=
 =?iso-2022-jp?B?ZTFhTUZvZVV5c0UrN09aYm5MOVcwNzRzMy9GQUZrYnpXa3ExSVhYTzlm?=
 =?iso-2022-jp?B?dm5xcElaT2NKVVdxOG9WSUZ3TWd0VnFzNnI1V2xuVHVETXhwc1dubzdO?=
 =?iso-2022-jp?B?a0hKdng2VWpnY2h5UXAzQnBvQU1zVlFzTjQ0a1JrWm9lUm1BbExOZXRi?=
 =?iso-2022-jp?B?VmxuUnlKdjRJbUF2djhwTHVCQ1dFeWgxY3hDYTg4clRwMUdkSXBvenZq?=
 =?iso-2022-jp?B?ZHB3WU0vZmIzbEVMMjVXSVdLNXBhYzVIWHNmWlg0bmhTRmdGK1pBM1dX?=
 =?iso-2022-jp?B?ZlF2bXlxUlp1QVBHemJVa1dtRmc0a2VYQVFncW5lQUs5VmRzVFhVSkhX?=
 =?iso-2022-jp?B?a2duTUloUDlrVGl3eGxTRndVODRMcVdtNE1uRDFCanA0RWN6eGM2azhr?=
 =?iso-2022-jp?B?eVplQTVnZVU2OFRWbHpvUWlSdGhDTUFWMVhhdTZvVnBVd2tkcS94Rmth?=
 =?iso-2022-jp?B?ZU1XQ1I1QnVKNDBuY2dlekpnREJLYmtIVG9vdGpsTmQ5aFBrN3IzTWdp?=
 =?iso-2022-jp?B?dzcwTWtMOStzOWJkWGc0QkNYLzcrOVBhUWI2V1NhNW50Znk1K1haUnM5?=
 =?iso-2022-jp?B?em5ITzcvanlnb0ZjZ2p4emhsMzFldnVGUG8wMHhRMndOaUxUS3VkU1R1?=
 =?iso-2022-jp?B?bDh3b2pFK0ttT293d05FdElQN3U3VlhMQVRmaEZudmRBNzFRL0E1c01w?=
 =?iso-2022-jp?B?Q2ZEdEdOL25zV3BuODRQUXdjT0J6aEVmMUtlaXdqaHhQcnFrN2ltRHBa?=
 =?iso-2022-jp?B?VmhFT1VUaTBsWUdhWmJpRFFNQ1MxOS85dnJWWWluSHlMMEhVMkZXdy9G?=
 =?iso-2022-jp?B?YjVQalBwY2dsUEZQNTRsZWRxS3ZrOTZrSG01WnlmODIwNFRpcEtnUjNq?=
 =?iso-2022-jp?B?NDhuM2h0alFPcFVJSVdHeEZ5aFpJb29rT0cyVDU2QjRJVWV1N1MzWERQ?=
 =?iso-2022-jp?B?Rk5hcWw2WDZiV3BWOFA5UGdYQVBXU2F2ZC95clZaS294ZG4zMS9uOHcx?=
 =?iso-2022-jp?B?ZGV6VWQ3T2dmdzdGYU94K3BwVktDbTc4aDRLWGdaME1XakVsNlVLRnha?=
 =?iso-2022-jp?B?bGxGR0JHSVZ5NHIzd1pIL3AzT1E5ZS9rUXZHbGtUalpoY1Y4MnFNcGpX?=
 =?iso-2022-jp?B?b3hrVE9sZE0ya04ySGVSQ2l1MVdVWi80bytQWGg1Z05oOStXUjJFSHht?=
 =?iso-2022-jp?B?OUhQQ1FWcFA1L0VsdnlxbXVBZGNqL1NWemMwTks5VHNjV2RFekt3Z3VQ?=
 =?iso-2022-jp?B?NEM1NVdRbjlyVWdqVEZJL2RJYUYrR2NsWGJCdFVrWXNhRFh3bWIyNklU?=
 =?iso-2022-jp?B?b29icTQybUw1OExxRis0RUVLSVpPeXZBcGJzUUFvYmxsZUxCSXBNZU9r?=
 =?iso-2022-jp?B?cjVnVm9UN0RXNjFUc3QyMml3elYzSE1WSkM1Vm8xajVSYXNvNDB3N3U3?=
 =?iso-2022-jp?B?eG1PcDNNdUo2UnFyV013dkFGbG1TQWtCRWRUYms4d09oSUt2Z25WTHhX?=
 =?iso-2022-jp?B?eDk5UlJyTk1Yalk5S1h3S2JjYkhlZ1Y4TzJOTklJSVlxc1RoamoxRmdT?=
 =?iso-2022-jp?B?RzhMYXFsMnJvUXcyZTAyY1l6L3JUalhnUUNsUzJMM1paaDNKUGNpeWgv?=
 =?iso-2022-jp?B?WVF4cnpmYzYraUx6ZDJMM0xqTFF0cGRFenFsd1VrZ0tEYXpTR1ovNXZj?=
 =?iso-2022-jp?B?djZOT1JuMHNRUzBHbTdQT3ZWaGNMZzA3Z1F2UEY0a01PK1pFNFV6Vm9D?=
 =?iso-2022-jp?B?Z1NpMjFnRkRlRTZCWW1ZMVBzWTRLNm9oVFNXZGZBQWVTQU0wSE9CcDYv?=
 =?iso-2022-jp?B?eGRURTdKQ2IyZk0xeSttb0ZjZHo5NXpuTUNIY05OTFBPU2J1eEZaRmZ1?=
 =?iso-2022-jp?B?dmlvMG1mZz0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	QK863yrltTwPyQNxeyOsLKXikfxxWbJdJkydMCJCS57P8gWgiS9nPVJ5iFBH9Eh6DnDCaNmiG3aR5STBYRpCW+tD8uskJPVhERhn7pKTtfwnwzAG8HW7L4FkRmfa9ZAiv/aWfBJj27vjxl7oZL+06JYFzqOAsWj7TGNYkN32GRyD2TlYmUNxqWgmiBR7LJY2mRaRZ6iGAnthVywJ+uIXnzfZ6mh1yrdW66/NT5x/0EqaKg0nUfVhK4XgSovNg3e0MlmlEUVESO/yvlI2c60WocRC1nRe+bIePIGXRPvM1UuaKJXYMdNqABHs/2KzzGs2r0/3D2OF5uQNhP6rruHi5g==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSCPR01MB15739.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6b0d57-2cba-42db-3971-08df2b856f42
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 13:00:20.6355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vHvFbZZ0kFAkwGOE1h28SMaYOdChIDSHE8rQgujlXJYY3GbZInMXKZfOuUyDqbdGO9nBzTRXydjAYZxtoNSSql8diB1AN6H+wEQN6+0DK3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB12287

Hi Mark,
Thanks for the reviews.

> Subject: Re: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MON=
AKA Erratum E#030002
>=20
> On Fri, Oct 16, 2026 at 07:00:47PM +0900, Tomohiro Misono wrote:
> > FUJITSU-MONAKA Erratum E#030002 affects FUJITSU-MONAKA CPU.
> >
> > On affected FUJITSU-MONAKA CPUs, after a PMU event counter is
> > stopped at a value just before overflow, an overflow might still
> > be incorrectly detected, resulting interrupt storm in some case.
> >
> > For example, if the following conditions are met:
> >   1) Running perf to count an event in user space only
> >   2) The event can also occur in kernel space
> >   3) The counter value is set just before the overflow
> >      (when using the -F option, initial counter value is -1)
> >
> > when the kernel is about to return to user space after enabling
> > the count, an overflow interrupt is incorrectly triggered by an
> > event that occurred in kernel space. Since the counter value is
> > not updated (correctly), the interrupt handler does nothing and
> > returns with the same condition. This leads to another wrong interrupt
> > and results in an interrupt storm and eventually a softlockup.
>=20
> I don't fully understand this.
>=20
> Surely the relevant PMOVS{CLR,SET}[n] bit set as if the counter n
> overflowed?
>=20
> If that bit is set, the handler will certainly do *something*.
>=20
> If that bit is not set, the interrupt shouldn't be asserted at all. When
> does it get de-asserted?

Sorry, my explanation wasn't clear. The interrupt will be de-asserted as us=
ual.
The problem is that armpmu_event_set_period() will not update the counter
value if, for example, the counter is -1. Therefore, false overflow detecti=
on will continue.
With this patch, armpmu_event_set_period() will force the counter to -6 so =
that
false overflow detection won't occur in the kernel, since the maximum event
count at a time is 5.

>=20
> > Work around the erratum by avoiding programming PMU event counters
> > with values within five counts of overflow.
>=20
> Without more detail, I don't think that can be sufficient, because you
> can end up in a scenario where:
>=20
> 1. The kernel confugures the counter to -5.
>=20
> 2. The kernel returns to userspace.
>=20
> 3. In userspace, 4 events occur, and are counted, leaving the counter at
>    -1.
>=20
> 4. Some unrelated interrupt is taken, entering the kernel.
>=20
> 5. Upon return to userspace, a kernel event occurs, triggering this
>    issue.
>=20
> 6. The PMU interupt handler runs, does nothing, leading right back to
>    the original issue.
>=20
> What am I missing?

When the interrupt is falsely triggered, armpmu_event_set_period() will
force the counter to -6 in this case too. Then, we can return to the user s=
pace
without triggering another false overflow.

I hope this answers your questions.
Best Regards,
Tomohiro Misono

>=20
> Mark.
>=20
> > Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>
> >
> > ---
> > Changes in v2:
> > - Add user impact explanation in the commit message
> > ---
> > ---
> >  Documentation/arch/arm64/silicon-errata.rst |  2 ++
> >  arch/arm64/Kconfig                          | 17 +++++++++++++++++
> >  arch/arm64/include/asm/cpucaps.h            |  2 ++
> >  arch/arm64/kernel/cpu_errata.c              | 10 ++++++++++
> >  arch/arm64/tools/cpucaps                    |  1 +
> >  drivers/perf/arm_pmu.c                      | 13 +++++++++++++
> >  6 files changed, 45 insertions(+)
> >
> > diff --git a/Documentation/arch/arm64/silicon-errata.rst
> b/Documentation/arch/arm64/silicon-errata.rst
> > index 527af20b26468..0efb24ec01b4c 100644
> > --- a/Documentation/arch/arm64/silicon-errata.rst
> > +++ b/Documentation/arch/arm64/silicon-errata.rst
> > @@ -377,6 +377,8 @@ stable kernels.
> >  +----------------+-----------------+-----------------+----------------=
-------------+
> >  | Fujitsu        | MONAKA          | E#030001        | FUJITSU_ERRATUM=
_030001      |
> >  +----------------+-----------------+-----------------+----------------=
-------------+
> > +| Fujitsu        | MONAKA          | E#030002        | FUJITSU_ERRATUM=
_030002      |
> > ++----------------+-----------------+-----------------+----------------=
-------------+
> >  +----------------+-----------------+-----------------+----------------=
-------------+
> >  | ASR            | ASR8601         | #8601001        | N/A            =
             |
> >  +----------------+-----------------+-----------------+----------------=
-------------+
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 5d1a17ab0f593..43fd265156e46 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -1361,6 +1361,23 @@ config FUJITSU_ERRATUM_030001
> >
> >  	  If unsure, say Y.
> >
> > +config FUJITSU_ERRATUM_030002
> > +	bool "FUJITSU-MONAKA erratum E#030002: PMU overflow may be incorrectl=
y detected"
> > +	depends on ARM_PMUV3
> > +	default y
> > +	help
> > +	  This option adds a workaround for FUJITSU-MONAKA erratum E#030002.
> > +	  On affected FUJITSU-MONAKA CPUs, after a PMU event counter is
> > +	  stopped at a value just before overflow, an overflow might still
> > +	  be incorrectly detected.
> > +
> > +	  Work around the erratum by avoiding programming PMU event counters
> > +	  with values within five counts of overflow.
> > +
> > +	  The workaround only affects the FUJITSU-MONAKA.
> > +
> > +	  If unsure, say Y.
> > +
> >  config HISILICON_ERRATUM_161600802
> >  	bool "Hip07 161600802: Erroneous redistributor VLPI base"
> >  	default y
> > diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/=
cpucaps.h
> > index 9220b917ec207..c0a0452daf949 100644
> > --- a/arch/arm64/include/asm/cpucaps.h
> > +++ b/arch/arm64/include/asm/cpucaps.h
> > @@ -68,6 +68,8 @@ cpucap_is_possible(const unsigned int cap)
> >  		return IS_ENABLED(CONFIG_ARM64_ERRATUM_4193714);
> >  	case ARM64_WORKAROUND_FUJITSU_030001:
> >  		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030001);
> > +	case ARM64_WORKAROUND_FUJITSU_030002:
> > +		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030002);
> >  	case ARM64_MPAM:
> >  		/*
> >  		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_err=
ata.c
> > index a11135f83e858..6363b694b4478 100644
> > --- a/arch/arm64/kernel/cpu_errata.c
> > +++ b/arch/arm64/kernel/cpu_errata.c
> > @@ -1048,6 +1048,16 @@ const struct arm64_cpu_capabilities arm64_errata=
[] =3D {
> >  					{}
> >  				})),
> >  	},
> > +#endif
> > +#ifdef CONFIG_FUJITSU_ERRATUM_030002
> > +	{
> > +		.desc =3D "FUJITSU-MONAKA Erratum E#030002",
> > +		.capability =3D ARM64_WORKAROUND_FUJITSU_030002,
> > +		ERRATA_MIDR_RANGE_LIST(((const struct midr_range[]) {
> > +					MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
> > +					{}
> > +				})),
> > +	},
> >  #endif
> >  	{
> >  		.desc =3D "Known broken GICv3 SEIS implementation",
> > diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> > index 1e57a0105395b..ef8ce70ab7121 100644
> > --- a/arch/arm64/tools/cpucaps
> > +++ b/arch/arm64/tools/cpucaps
> > @@ -133,3 +133,4 @@ WORKAROUND_SPECULATIVE_SSBS
> >  WORKAROUND_SPECULATIVE_UNPRIV_LOAD
> >  WORKAROUND_BROKEN_AMU_CONSTCNT
> >  WORKAROUND_FUJITSU_030001
> > +WORKAROUND_FUJITSU_030002
> > diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
> > index 1150695653892..c0b8580d80bae 100644
> > --- a/drivers/perf/arm_pmu.c
> > +++ b/drivers/perf/arm_pmu.c
> > @@ -234,6 +234,19 @@ int armpmu_event_set_period(struct perf_event *eve=
nt)
> >  	if (left > (max_period >> 1))
> >  		left =3D (max_period >> 1);
> >
> > +#if IS_ENABLED(CONFIG_ARM64)
> > +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_FUJITSU_030002)) {
> > +		/*
> > +		 * Due to the errata, overflow might be incorrectly detected in the =
handler
> > +		 * when the counter is about to overflow in a single increment, resu=
lting
> > +		 * interrupt storm in some case. As the counter can increase by up t=
o
> > +		 * 5 at a time, set 6 here to prevent the condition.
> > +		 */
> > +		if (left > 0 && left < 6)
> > +			left =3D 6;
> > +	}
> > +#endif
> > +
> >  	local64_set(&hwc->prev_count, (u64)-left);
> >
> >  	armpmu->write_counter(event, (u64)(-left) & max_period);
> >
> > --
> > 2.43.0
> >
