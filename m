Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21236E46C
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 04:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788151635; cv=fail; b=QSn0R49mhwqa1XQvsXuFd7fe632xFjew7sKgLOlBGAH3bdsYn4bYfhqSYA2JSO+SUBLMSbDCHkZETjv//TrrsFtWkkYr/q5OP6bJcjRs4fUl1wdWcL0JDugcgjTdvfDByeZGMISJiwUrBes9FzzNqoCHqm9GI0wZdNO9AOF0Ea4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788151635; c=relaxed/simple;
	bh=q/t/sC0IsRz57Vo9qdSIGfi2byco/XG+o9yPEU0gJM8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U3v+pv9dclgIAsrOfagu3FJzL2rC29fZH8ETXDt8YT7lsnwQfPAnHjz7zXmQVhniATCWiRLlB7+3l3l5K7KvwHaA5RlIt/KPHND30/u8NTRdmPkE+BZfFmTD45OjrayW7ts1+bZ/JONXOX8rgJub0V+D+nhKelwhwx2ENQhEFt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=cWtZ8OOo; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fB5ZcaEi; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="cWtZ8OOo";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fB5ZcaEi"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V1cT2N2165610;
	Sun, 30 Aug 2026 21:46:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=q/t/sC0IsRz57Vo9qdSIGfi2byco/XG+o9yPEU0gJ
	M8=; b=cWtZ8OOoxjHwrMTkfPf4uF5kSK3zWMrfkJfk+qEvqXdM4KkUghbteoPAD
	fp6QvfuTOaCtUgBVQ+D1ALrBhehODN621gdErgcZA9aecpe9z2EOVfWcmlZCGYdh
	Kk3jBbxoKEnMYu0UVt/t/YxB4YYlvbmazc0OdV1bO7vI4EBeR0dQKDAPUGU2Ab8G
	0Hh0fiuvuDQLgqE382iqEcWxWi2XSiNTKrnDcm1gVv87/GHMoGpUTs8V0MhDMcE9
	Sk2ftiRMpvg+H7DUN22QAX9lD1CcKwk80As+oAvWx5WC1ULirYLCk501WcYPTgO/
	pOS7yaw0xiR44IfPwZrGPyFaLvH6g==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020142.outbound.protection.outlook.com [52.101.193.142])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gbxxy29c5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 30 Aug 2026 21:46:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R10CXdHOWdN+ZgVDONCJgjLUx3l3Ix2zNYyxEifaykwumyDiq+p9VxsblKEvk+hZgT5xlSnMKNOizlS9YCQZChZLQkOVmwAjX5bOl/tcHwd/zNfb7hbXUExuhpRIR2gL5x/Iyh4T7EECl1jKCgt0SjXYiRm2FDA9QpGnUz8yVEWKKXnB2gk60kj9qhu/ODeA2cVBnywR7K3xdXPOTr8/P0/tRuSfI15TBSWvl/yKnB9SHZ3cXufoz0pV8QNYdhtfQQx7GcwcpiBElJvYVYtx+1SnguLTSW9nGTOGX5DV/jg49QoQpiBiKdjdcCT8MdjmvXi8iRRi/7kn3ZZdVGuF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/t/sC0IsRz57Vo9qdSIGfi2byco/XG+o9yPEU0gJM8=;
 b=yXS8YpzYh4jN1NkV4zuN/GVuc5YwMqbRGlfLtbLH7y97i2bdAWGGLJlaO2BUUhkb2L9NKZOlxjiVxAn1Np5MWqzBxyciXG8u4IAaOQm0Wx4gRVpB17QMSCbDGwiPWdF0EgBifhW+PM8GlZumgJKqxofdq10sqOmUfLOLlfO6NxVHEvugqP2eS0PDfiXVJBmDU5cWriQag5nGXVoPyyxZ7JhI5HrKqETP4DsmFVp1AEKkeBYwazakCVkQKFi7Au0iE/I08SGIghagiUSHoiZkk7IBj3FAkhuBqRglz9+U3jjQ1qnUXDKc5o92eQk7nN5sgKVxA6mF72zQWeuIUUTEKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/t/sC0IsRz57Vo9qdSIGfi2byco/XG+o9yPEU0gJM8=;
 b=fB5ZcaEi6VRsvVDTv6AtrpCjQAhiugsa8VhFp2AbsfKQxAnPFz1yFdK3p9WBc3D5cw5YiruqkebkTuOqlP60tN0Fav/jLiF9niFEcW0saynziP4WTIKxK4UF+OOZGNnYq6iuyv30XLnpmJHnWPzpU7W8HdvOf0VsuBCxBqU0EC0x5ae7yNWyz6Kxfncnkh42GUmTiY0ShJxqw47jDVhpdLbBebOKZmT40h5JoYveIlKfzpRCPXIoByTNvBXSn54r/E93Mm0BNAnAIG8DgAtmDOoiOXXLqCO1jorMPZ5ouIiA99/dB7CpBAMCtM7SDnm0jqJeIe3dpFVmrIAqico/sw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6487.namprd02.prod.outlook.com (2603:10b6:a03:1c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Mon, 31 Aug
 2026 04:46:19 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 04:46:19 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Shameer Kolothum
	<skolothumtho@nvidia.com>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "maz@kernel.org"
	<maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org"
	<will@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com"
	<eric.auger@redhat.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "wangzhou1@hisilicon.com"
	<wangzhou1@hisilicon.com>,
        "jiangkunkun@huawei.com" <jiangkunkun@huawei.com>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        "anthony.jebson@huawei.com" <anthony.jebson@huawei.com>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "linuxarm@huawei.com"
	<linuxarm@huawei.com>
Subject: Re: [PATCH v8 5/6] smccc/kvm_guest: Enable errata based on
 implementation CPUs
Thread-Topic: [PATCH v8 5/6] smccc/kvm_guest: Enable errata based on
 implementation CPUs
Thread-Index: AQHdOQOqpaaHltXcgkix37+MBM7WLg==
Date: Mon, 31 Aug 2026 04:46:19 +0000
Message-ID: <FA27FD8D-C029-4DED-9930-5903235099C7@nutanix.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
 <20250221140229.12588-6-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20250221140229.12588-6-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BY5PR02MB6487:EE_
x-ms-office365-filtering-correlation-id: 1398afc0-da5e-4802-719b-08df071accc1
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|38070700021|10067099003|5023799004|56012099006|4143699003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 SDGhBbnyKbFl/vCRIJ+70UNYlXhc0eMb5++NiIqLZjsKM0lPHcaXP7TGrj4nf6kO+8dh5S/nGdGqvvmsXSoTokahK2wXaN9l4lkW6pCeJYkcwMGNPaC4ouIUCeIGMRLfcXLIFT7r8BHPJJGvqhZJw2f7GLERnm12RVyacIYSGVBeY+Mgj1MOIpHs3vzszyRZzin0OZrEv95J9RE49BXlMm+Hv9vCxfbv2wPHz1KCtfoPpttD7kqBh88iiOnWuFplpnlKCzMu2ZN38vz4rYyUCG4gXR48eRO7nDfAHsWSK3cKtwVU5uXk2M50R3c8y6SLAsHiXznD9AM4U3oQp9PnPahsI1gOO6gyt5nIxP8+1AWPUtupzcD9Z+OmUe0V1Ai5CBPKVQYh/lRPKnTH/QiaIboTEoOfIxslk/iU8jzp4+r26zOoro/eTOwq4KpWFyXMBk8hsod9070l4/RNXyMgw4SkhQFQXd6cfJx1zRks2TlCF8p5h/YzfTwGIoYh4Vu/wZro6kmTVtTZa4iRw5JxhFcdAjQ2S1otSoLlsAx9In3EOqPOI99Kwz3tUzEhBr09Q+xj6WetUIWhry8L9H9/QG2pLAeejIEgF2gk6k+BSxFLbrnfuy8F9qrR9uzawD0rkFMrgrkl/G8W542dTEgTThMS5xRXZkBVs4SAvPbUDzcF7B7Vc5gDgzxibmTjqJNOUSg/XJzFH7BKliIed75chveVaV9EUYgnu2LNRZAvvYg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(38070700021)(10067099003)(5023799004)(56012099006)(4143699003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cUJZZEJNR2lZRFJYVHo0MjYrRTNyMkZSbTBRTG02WGc2WnFsWHoyQmJPQ0pZ?=
 =?utf-8?B?enhrVDFGbUNkdUxDMW5NK0l2Lzk1MlJaMytuZjRoRFp4b3NNZUMvTXZjWnVu?=
 =?utf-8?B?aTVBRXNsVVp2TFJFSGJXTTRWTWFxWnB6NDg3MXF0c0k3OFh3MjhXVkQySzB0?=
 =?utf-8?B?OVM2NUF4UU1objdMcVd2aG1ZZ2ZHcTZMR1B3UW8zdGJuUUU3a1h1YjFyN2JO?=
 =?utf-8?B?aW5UNTY3U3BEOStOVUNBK2Qybmh2YndtVStDWnRJdm13MWVTVzZCeVJocFJi?=
 =?utf-8?B?cW9wbEp6ZmhneTNJSUFtUGVVVzNqVGJBeEtOTnptQlBvYXRBbmMwOUR2RWp0?=
 =?utf-8?B?SzN5Q3FmR2VyalhiZFNtTUFYMDIwWGlFNUxPQVl3M0NTaXR1d21BaHZXL2RP?=
 =?utf-8?B?LzNXTjZQWTBvbW1lYWIzQWZQZk5KS3VDbHB2aHBXSnZWUzZpSytNaEJxUkE3?=
 =?utf-8?B?VjJqeHNZQ3BuV2o4QndFdUZ6bXdSWHRybGJoLzM4SXNrbXY3U0x6Q3dIZzho?=
 =?utf-8?B?N2NEU1BJMjJaeldZbmh3dlV4TURkd3pPdzN4ZGppWm1CdUtWZUFBaXdWYjAy?=
 =?utf-8?B?dWtJTEY4cEJYclhxRXN1a2JCL0FXS3RVelo4ZlB5UHJHMnB3Z2dxNm9wTTlC?=
 =?utf-8?B?Ulp1NTJXcmFpcWJpaTZPaTJWbXVOQTFkTXU2dFlOMTVjOTJ2bXFvS0xiZE5r?=
 =?utf-8?B?Vm1FWmNXcU14am5QMTY2MDQrSjQyMHdFV3JTRXBiOWhWS3A2cWFMMytlLzdi?=
 =?utf-8?B?MUQ2eEhyeFVUeHVwZGZqbmF0YXlDU25aZUYxWmI4Y29IbFJNZnVTYzNBMThV?=
 =?utf-8?B?Uzg4VmJzVGJIK3NjRENvU2g4Snp4ZndpSFdoMlZ1RzN0clk3czhKN3RvcWNp?=
 =?utf-8?B?b1g4aVk0ek9qZ1oyUVJiUU5pc1JTN1ZpUGRHcCsxYUZyb2hnYlZGTkJBOGdR?=
 =?utf-8?B?RDNobHpxNUswYmVqZ0FNcUg0VnR3SEVKUzJnNTlGV1lNcmZSMnUwS0twdHpx?=
 =?utf-8?B?MlVVVUpaVTFkalJCZnF4ZHZ3N1N2UXNCTXMxajhJaEF1Uk9vR2J5NUdycUxi?=
 =?utf-8?B?cVZRTFlucFdzcmVwbTFxWEVVZFNKaC9vQUd3NkI3K0JNbk9lM1E4dG1LeEdX?=
 =?utf-8?B?Z0RKOS9ZL1VrWk1FRklHbkV3Q3FyZTJoNmpaTUN3czYrWDcvSUhldmlseFdY?=
 =?utf-8?B?Q0w1SVM2b1owSjZ5Qk45RVJsZkRUcWpwaHptZXRoM2RHR2F5Yk03R1ZkdG1a?=
 =?utf-8?B?c1RYVUxMdVZaOWZCMW81b1A1OHp6VzVlWWN3N0tJN2g5M2tsd0V4N0FIalpJ?=
 =?utf-8?B?dmJBNTVoSXNqdHhuMVJRclg5RVhBVHlDNHRFN3RuRWkrbHdHcnJvY0M5V0lv?=
 =?utf-8?B?NXJIVGJMeVM5eVJuWTI1TUUzRU55dzZBWXR5c0p6Yk9QbzJKVC9TR1NKcTRy?=
 =?utf-8?B?QTJSdWJZVXNNd0ZaR2lYMEljWmZKeVp6bXErY005bVZpUVgwSTlPTlNOUkVr?=
 =?utf-8?B?UGxnREg2enN4aHozVmJFT3Q2TU1scjFZeDJXY2phMFRZSzd4QVpOVmJTZWxo?=
 =?utf-8?B?NkM1c2hHeXZSWUNWeEtQRUNqay9xRW5YQVVLZmVBalRPNVZ2KzNINmRpQ0s5?=
 =?utf-8?B?T0l1cXhhNm0rOFMyd2hFcXk3MDBFSmhrYjg0MmRRWStpL1A2VGlNdXJMaEdB?=
 =?utf-8?B?RithQXo0M1EwZnpCaXl2azdHU3VETUdHdUd6UE5ORGV5cGQ2TVhtUm1KNHpj?=
 =?utf-8?B?YjFndDh4R2psR2hnUEJmRXNyb2hHcXFqK0FOWG1jZ3Roa0tDUGhlbzVaT2NY?=
 =?utf-8?B?eU5VTGNaUThod2FhbGw3dEZZaHFOdUFVQXEyRE5oeDUwQ2pHZTZ2c0NLcXRx?=
 =?utf-8?B?RmlLeGQ4OVNRZTdLeURJOG91Ulo1bVF1QS96dEZhOEZ6SU52TnVsYjdQVkJW?=
 =?utf-8?B?MlNCVTlRdlc3a0VQVFVKa1kyNXQyVlVkZWRtOEE3aS9Rb09hMm1oNE9UaWt1?=
 =?utf-8?B?aDBpalBiWXlZaEY0ckpVK1pTSGw1ZjcyY3E5SkJiMjgvT2pQOVpiVFBCR1My?=
 =?utf-8?B?OUJuVXA3Z3U4a0ZHZm9oellIaDljRDgwbmRhYlRmZ2doRTFHYm1sc0FHb1lM?=
 =?utf-8?B?TkFwdFc3YmFwNkgzTlZMeU4xZjBLckE5eitNWUltT3l5Z0NyMWFSSTdkM2FL?=
 =?utf-8?B?Vzlma1hXVzJUREI0ME1XKzRkMGJ5Z2NSZUF4VHRLMWo1ME9Bd1h6Vlg2RWdB?=
 =?utf-8?B?QzhwblhzQ1gvaTZ4YkM3aEdscjJ2REo5TWZDZ2xpcHVOWCtsaURQNEloa2Rm?=
 =?utf-8?B?T2VnWlEwS21saGFtUG1BSDNRZHMwcXRQN0YydkZKTUxDYktBRnJFb1F0Mjla?=
 =?utf-8?Q?j/SbJFc1EvypwNTI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C28F7806FD8C8D45BA91306B3AC0937D@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	dtFLJ5d1nDHavLkQlNeSDsJchbNzaLZIOgGOjZkbt0TgV/u9/N59TYcZhIUbxOlvlP1mDqM5GI5Z09SydRSe7UnHqlZpuslGsvm6rilwkHfhGsC8pJG5W8iyaVnYp+jWaRZqvFVpM+AiArl9KUvetV5rfnP9g/4oHuhg8DYSjMYjoZkeGpEHeZPHRVJPvjWULB/9/3Lzv6w+wxnRw5YnWPlwHzDjC3ppKgz+eWNCz/yd2vjj5uMCM7zv5kbIFKbZjvOegJOw1f2V1itNseoJizCYkd3fs1jGFobJtTAN3mQef52ArN9vQ590Me4IC6MiLvKikGQpaRFzyehiNxBbTw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1398afc0-da5e-4802-719b-08df071accc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2026 04:46:19.5476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I8GTxCzYndHXUA/k/17gGKGDnDMZ37L9tyVyh+IoCn0AGAoYABZ63c2w5bi2Zfm68kch6R7tZmxCQzm6Kw5ia3yWJ1TpITQp3uZdPhEWM70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6487
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDAzOCBTYWx0ZWRfX4MO05ZQeZx/v
 nWHpWo17FXTnz3+hnJEq1gcqDg6cdACN1j+3t9KBc4U9/S8AHBNI5q2VP3Uviw7VCLyxqPm86Fz
 BWkMPymPlqg7osueyyVA/dzJy3keEF8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDAzOCBTYWx0ZWRfX3EdGw9CJzntn
 MLWRPO/AJii3b47whI361vRRXSatlu/PN1khC/xc7LkapGp1ccvtf4c6c2DelKKfmW4WZa3465u
 9j9OsJehS9pbOq0Unns9lb/hefvsqB350Y6oti/IVyREzbtPP96ejKj6fykAGq+NXdID8sH85Vn
 bUao8isdFF3BqtGGeVMM231V6han+szN5QKlgZ2Gnx2G2nPzw5mmHwCkFolpeKe/6n8uWRbt4oS
 EwKM8pRS0LNJxxq5DxcMse7HZ2Fqmuu+YoX6TNyA176EXNqSRTTTX2l8+j6BZVJkzykiDSjo86p
 t2WIXRrSIm+/oTAmIbCK+JyWywij7oTxnjS1WyPW4dA8vfZJ1OikvBlmZAJsGy/V07c7zqI5+LP
 g3PAhTKSJ3fddOMQ2xaA+xvln/+oug1n/hvehFweX6LpGfvvK0JSrKXbE7QNCIcJnW6JSE8gzBs
 miQHf9dVTwpb5W/yVQA==
X-Proofpoint-GUID: Jvo_z6hP2or-zuJfJeKXndT7Tm4SJa1A
X-Authority-Analysis: v=2.4 cv=SZHHsPRu c=1 sm=1 tr=0 ts=6a95071e cx=c_pps
 a=4hwGk4Ee9vGu72pLTFfh5A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=i0EeH86SAAAA:8
 a=20KFwNOVAAAA:8 a=Et1_fM3SowIc4DHnB2IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Jvo_z6hP2or-zuJfJeKXndT7Tm4SJa1A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_01,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjEgRmViIDIwMjUsIGF0IDc6MzLigK9QTSwgU2hhbWVlciBLb2xvdGh1bSA8c2hh
bWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPiB3cm90ZToNCj4gDQo+IFJldHJpZXZl
IGFueSBtaWdyYXRpb24gdGFyZ2V0IGltcGxlbWVudGF0aW9uIENQVXMgdXNpbmcgdGhlIGh5cGVy
Y2FsbA0KPiBhbmQgZW5hYmxlIGFzc29jaWF0ZWQgZXJyYXRhLg0KPiANCj4gUmV2aWV3ZWQtYnk6
IENvcm5lbGlhIEh1Y2sgPGNvaHVja0ByZWRoYXQuY29tPg0KPiBSZXZpZXdlZC1ieTogU2ViYXN0
aWFuIE90dCA8c2Vib3R0QHJlZGhhdC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNoYW1lZXIgS29s
b3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gLS0tDQo+IGFy
Y2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1dHlwZS5oICAgIHwgIDcgKysrKw0KPiBhcmNoL2FybTY0
L2luY2x1ZGUvYXNtL2h5cGVydmlzb3IuaCB8ICAxICsNCj4gYXJjaC9hcm02NC9rZXJuZWwvY3B1
X2VycmF0YS5jICAgICAgfCA0NSArKysrKysrKysrKysrKysrKy0tLQ0KPiBhcmNoL2FybTY0L2tl
cm5lbC9jcHVmZWF0dXJlLmMgICAgICB8ICAyICsNCj4gZHJpdmVycy9maXJtd2FyZS9zbWNjYy9r
dm1fZ3Vlc3QuYyAgfCA2NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA1IGZpbGVz
IGNoYW5nZWQsIDExNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1dHlwZS5oIGIvYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9jcHV0eXBlLmgNCj4gaW5kZXggY2NiNGExNTVkMTE4Li5jYzJkNTgxNDFiZTEgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1dHlwZS5oDQo+ICsrKyBiL2Fy
Y2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1dHlwZS5oDQo+IEBAIC0yNzYsNiArMjc2LDEzIEBAIHN0
YXRpYyBpbmxpbmUgYm9vbCBtaWRyX2lzX2NwdV9tb2RlbF9yYW5nZSh1MzIgbWlkciwgdTMyIG1v
ZGVsLCB1MzIgcnZfbWluLA0KPiByZXR1cm4gX21vZGVsID09IG1vZGVsICYmIHJ2ID49IHJ2X21p
biAmJiBydiA8PSBydl9tYXg7DQo+IH0NCj4gDQo+ICtzdHJ1Y3QgdGFyZ2V0X2ltcGxfY3B1IHsN
Cj4gKyB1NjQgbWlkcjsNCj4gKyB1NjQgcmV2aWRyOw0KPiArIHU2NCBhaWRyOw0KPiArfTsNCj4g
Kw0KPiArYm9vbCBjcHVfZXJyYXRhX3NldF90YXJnZXRfaW1wbCh1NjQgbnVtLCB2b2lkICppbXBs
X2NwdXMpOw0KPiBib29sIGlzX21pZHJfaW5fcmFuZ2VfbGlzdChzdHJ1Y3QgbWlkcl9yYW5nZSBj
b25zdCAqcmFuZ2VzKTsNCj4gDQo+IHN0YXRpYyBpbmxpbmUgdTY0IF9fYXR0cmlidXRlX2NvbnN0
X18gcmVhZF9jcHVpZF9tcGlkcih2b2lkKQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9oeXBlcnZpc29yLmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2h5cGVydmlzb3Iu
aA0KPiBpbmRleCA0MDllMjM5ODM0ZDEuLmExMmZkODk3Yzg3NyAxMDA2NDQNCj4gLS0tIGEvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9oeXBlcnZpc29yLmgNCj4gKysrIGIvYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9oeXBlcnZpc29yLmgNCj4gQEAgLTYsNiArNiw3IEBADQo+IA0KPiB2b2lkIGt2bV9p
bml0X2h5cF9zZXJ2aWNlcyh2b2lkKTsNCj4gYm9vbCBrdm1fYXJtX2h5cF9zZXJ2aWNlX2F2YWls
YWJsZSh1MzIgZnVuY19pZCk7DQo+ICt2b2lkIGt2bV9hcm1fdGFyZ2V0X2ltcGxfY3B1X2luaXQo
dm9pZCk7DQo+IA0KPiAjaWZkZWYgQ09ORklHX0FSTV9QS1ZNX0dVRVNUDQo+IHZvaWQgcGt2bV9p
bml0X2h5cF9zZXJ2aWNlcyh2b2lkKTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva2VybmVs
L2NwdV9lcnJhdGEuYyBiL2FyY2gvYXJtNjQva2VybmVsL2NwdV9lcnJhdGEuYw0KPiBpbmRleCAx
ZjUxY2Y2Mzc4YzUuLjY2ODY5ZDgxYzNkNSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rZXJu
ZWwvY3B1X2VycmF0YS5jDQo+ICsrKyBiL2FyY2gvYXJtNjQva2VybmVsL2NwdV9lcnJhdGEuYw0K
PiBAQCAtMTQsMTAgKzE0LDM0IEBADQo+ICNpbmNsdWRlIDxhc20va3ZtX2FzbS5oPg0KPiAjaW5j
bHVkZSA8YXNtL3NtcF9wbGF0Lmg+DQo+IA0KPiArc3RhdGljIHU2NCB0YXJnZXRfaW1wbF9jcHVf
bnVtOw0KPiArc3RhdGljIHN0cnVjdCB0YXJnZXRfaW1wbF9jcHUgKnRhcmdldF9pbXBsX2NwdXM7
DQo+ICsNCj4gK2Jvb2wgY3B1X2VycmF0YV9zZXRfdGFyZ2V0X2ltcGwodTY0IG51bSwgdm9pZCAq
aW1wbF9jcHVzKQ0KPiArew0KPiArIGlmICh0YXJnZXRfaW1wbF9jcHVfbnVtIHx8ICFudW0gfHwg
IWltcGxfY3B1cykNCj4gKyByZXR1cm4gZmFsc2U7DQo+ICsNCj4gKyB0YXJnZXRfaW1wbF9jcHVf
bnVtID0gbnVtOw0KPiArIHRhcmdldF9pbXBsX2NwdXMgPSBpbXBsX2NwdXM7DQo+ICsgcmV0dXJu
IHRydWU7DQo+ICt9DQo+ICsNCj4gc3RhdGljIGlubGluZSBib29sIGlzX21pZHJfaW5fcmFuZ2Uo
c3RydWN0IG1pZHJfcmFuZ2UgY29uc3QgKnJhbmdlKQ0KPiB7DQo+IC0gcmV0dXJuIG1pZHJfaXNf
Y3B1X21vZGVsX3JhbmdlKHJlYWRfY3B1aWRfaWQoKSwgcmFuZ2UtPm1vZGVsLA0KPiAtICAgICAg
IHJhbmdlLT5ydl9taW4sIHJhbmdlLT5ydl9tYXgpOw0KPiArIGludCBpOw0KPiArDQo+ICsgaWYg
KCF0YXJnZXRfaW1wbF9jcHVfbnVtKQ0KPiArIHJldHVybiBtaWRyX2lzX2NwdV9tb2RlbF9yYW5n
ZShyZWFkX2NwdWlkX2lkKCksIHJhbmdlLT5tb2RlbCwNCj4gKyAgICAgICByYW5nZS0+cnZfbWlu
LCByYW5nZS0+cnZfbWF4KTsNCj4gKw0KPiArIGZvciAoaSA9IDA7IGkgPCB0YXJnZXRfaW1wbF9j
cHVfbnVtOyBpKyspIHsNCj4gKyBpZiAobWlkcl9pc19jcHVfbW9kZWxfcmFuZ2UodGFyZ2V0X2lt
cGxfY3B1c1tpXS5taWRyLA0KPiArICAgIHJhbmdlLT5tb2RlbCwNCj4gKyAgICByYW5nZS0+cnZf
bWluLCByYW5nZS0+cnZfbWF4KSkNCj4gKyByZXR1cm4gdHJ1ZTsNCj4gKyB9DQo+ICsgcmV0dXJu
IGZhbHNlOw0KPiB9DQo+IA0KPiBib29sIGlzX21pZHJfaW5fcmFuZ2VfbGlzdChzdHJ1Y3QgbWlk
cl9yYW5nZSBjb25zdCAqcmFuZ2VzKQ0KPiBAQCAtNDcsOSArNzEsMjAgQEAgX19pc19hZmZlY3Rl
ZF9taWRyX3JhbmdlKGNvbnN0IHN0cnVjdCBhcm02NF9jcHVfY2FwYWJpbGl0aWVzICplbnRyeSwN
Cj4gc3RhdGljIGJvb2wgX19tYXliZV91bnVzZWQNCj4gaXNfYWZmZWN0ZWRfbWlkcl9yYW5nZShj
b25zdCBzdHJ1Y3QgYXJtNjRfY3B1X2NhcGFiaWxpdGllcyAqZW50cnksIGludCBzY29wZSkNCj4g
ew0KPiAtIFdBUk5fT04oc2NvcGUgIT0gU0NPUEVfTE9DQUxfQ1BVIHx8IHByZWVtcHRpYmxlKCkp
Ow0KPiAtIHJldHVybiBfX2lzX2FmZmVjdGVkX21pZHJfcmFuZ2UoZW50cnksIHJlYWRfY3B1aWRf
aWQoKSwNCj4gLSByZWFkX2NwdWlkKFJFVklEUl9FTDEpKTsNCj4gKyBpbnQgaTsNCj4gKw0KPiAr
IGlmICghdGFyZ2V0X2ltcGxfY3B1X251bSkgew0KPiArIFdBUk5fT04oc2NvcGUgIT0gU0NPUEVf
TE9DQUxfQ1BVIHx8IHByZWVtcHRpYmxlKCkpOw0KPiArIHJldHVybiBfX2lzX2FmZmVjdGVkX21p
ZHJfcmFuZ2UoZW50cnksIHJlYWRfY3B1aWRfaWQoKSwNCj4gKyByZWFkX2NwdWlkKFJFVklEUl9F
TDEpKTsNCj4gKyB9DQo+ICsNCj4gKyBmb3IgKGkgPSAwOyBpIDwgdGFyZ2V0X2ltcGxfY3B1X251
bTsgaSsrKSB7DQo+ICsgaWYgKF9faXNfYWZmZWN0ZWRfbWlkcl9yYW5nZShlbnRyeSwgdGFyZ2V0
X2ltcGxfY3B1c1tpXS5taWRyLA0KPiArICAgICB0YXJnZXRfaW1wbF9jcHVzW2ldLm1pZHIpKQ0K
VHlwbz8gU2hvdWxkbid0IHRoZSBzZWNvbmQgYXJnIGJlIHRhcmdldF9pbXBsX2NwdXNbaV0ucmV2
aWRyPw0KDQo+ICsgcmV0dXJuIHRydWU7DQo+ICsgfQ0KPiArIHJldHVybiBmYWxzZTsNCj4gfQ0K
PiANCj4gc3RhdGljIGJvb2wgX19tYXliZV91bnVzZWQNCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva2VybmVsL2NwdWZlYXR1cmUuYyBiL2FyY2gvYXJtNjQva2VybmVsL2NwdWZlYXR1cmUuYw0K
PiBpbmRleCA3MmU4NzZmMzdjZDQuLjVjNjFkOWQ5ZjA5NyAxMDA2NDQNCj4gLS0tIGEvYXJjaC9h
cm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jDQo+ICsrKyBiL2FyY2gvYXJtNjQva2VybmVsL2NwdWZl
YXR1cmUuYw0KPiBAQCAtODYsNiArODYsNyBAQA0KPiAjaW5jbHVkZSA8YXNtL2t2bV9ob3N0Lmg+
DQo+ICNpbmNsdWRlIDxhc20vbW11X2NvbnRleHQuaD4NCj4gI2luY2x1ZGUgPGFzbS9tdGUuaD4N
Cj4gKyNpbmNsdWRlIDxhc20vaHlwZXJ2aXNvci5oPg0KPiAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nv
ci5oPg0KPiAjaW5jbHVkZSA8YXNtL3NtcC5oPg0KPiAjaW5jbHVkZSA8YXNtL3N5c3JlZy5oPg0K
PiBAQCAtMzY3OSw2ICszNjgwLDcgQEAgdW5zaWduZWQgbG9uZyBjcHVfZ2V0X2VsZl9od2NhcDMo
dm9pZCkNCj4gDQo+IHN0YXRpYyB2b2lkIF9faW5pdCBzZXR1cF9ib290X2NwdV9jYXBhYmlsaXRp
ZXModm9pZCkNCj4gew0KPiArIGt2bV9hcm1fdGFyZ2V0X2ltcGxfY3B1X2luaXQoKTsNCj4gLyoN
Cj4gKiBUaGUgYm9vdCBDUFUncyBmZWF0dXJlIHJlZ2lzdGVyIHZhbHVlcyBoYXZlIGJlZW4gcmVj
b3JkZWQuIERldGVjdA0KPiAqIGJvb3QgY3B1Y2FwcyBhbmQgbG9jYWwgY3B1Y2FwcyBmb3IgdGhl
IGJvb3QgQ1BVLCB0aGVuIGVuYWJsZSBhbmQNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZmlybXdh
cmUvc21jY2Mva3ZtX2d1ZXN0LmMgYi9kcml2ZXJzL2Zpcm13YXJlL3NtY2NjL2t2bV9ndWVzdC5j
DQo+IGluZGV4IGYzMzE5YmUyMGIzNi4uMmYwM2I1ODJjMjk4IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL2Zpcm13YXJlL3NtY2NjL2t2bV9ndWVzdC5jDQo+ICsrKyBiL2RyaXZlcnMvZmlybXdhcmUv
c21jY2Mva3ZtX2d1ZXN0LmMNCj4gQEAgLTYsOCArNiwxMSBAQA0KPiAjaW5jbHVkZSA8bGludXgv
Yml0bWFwLmg+DQo+ICNpbmNsdWRlIDxsaW51eC9jYWNoZS5oPg0KPiAjaW5jbHVkZSA8bGludXgv
a2VybmVsLmg+DQo+ICsjaW5jbHVkZSA8bGludXgvbWVtYmxvY2suaD4NCj4gI2luY2x1ZGUgPGxp
bnV4L3N0cmluZy5oPg0KPiANCj4gKyNpbmNsdWRlIDx1YXBpL2xpbnV4L3BzY2kuaD4NCj4gKw0K
PiAjaW5jbHVkZSA8YXNtL2h5cGVydmlzb3IuaD4NCj4gDQo+IHN0YXRpYyBERUNMQVJFX0JJVE1B
UChfX2t2bV9hcm1faHlwX3NlcnZpY2VzLCBBUk1fU01DQ0NfS1ZNX05VTV9GVU5DUykgX19yb19h
ZnRlcl9pbml0ID0geyB9Ow0KPiBAQCAtNTEsMyArNTQsNjQgQEAgYm9vbCBrdm1fYXJtX2h5cF9z
ZXJ2aWNlX2F2YWlsYWJsZSh1MzIgZnVuY19pZCkNCj4gcmV0dXJuIHRlc3RfYml0KGZ1bmNfaWQs
IF9fa3ZtX2FybV9oeXBfc2VydmljZXMpOw0KPiB9DQo+IEVYUE9SVF9TWU1CT0xfR1BMKGt2bV9h
cm1faHlwX3NlcnZpY2VfYXZhaWxhYmxlKTsNCj4gKw0KPiArdm9pZCAgX19pbml0IGt2bV9hcm1f
dGFyZ2V0X2ltcGxfY3B1X2luaXQodm9pZCkNCj4gK3sNCj4gKyBpbnQgaTsNCj4gKyB1MzIgdmVy
Ow0KPiArIHU2NCBtYXhfY3B1czsNCj4gKyBzdHJ1Y3QgYXJtX3NtY2NjX3JlcyByZXM7DQo+ICsg
c3RydWN0IHRhcmdldF9pbXBsX2NwdSAqdGFyZ2V0Ow0KPiArDQo+ICsgaWYgKCFrdm1fYXJtX2h5
cF9zZXJ2aWNlX2F2YWlsYWJsZShBUk1fU01DQ0NfS1ZNX0ZVTkNfRElTQ09WRVJfSU1QTF9WRVIp
IHx8DQo+ICsgICAgIWt2bV9hcm1faHlwX3NlcnZpY2VfYXZhaWxhYmxlKEFSTV9TTUNDQ19LVk1f
RlVOQ19ESVNDT1ZFUl9JTVBMX0NQVVMpKQ0KPiArIHJldHVybjsNCj4gKw0KPiArIGFybV9zbWNj
Y18xXzFfaW52b2tlKEFSTV9TTUNDQ19WRU5ET1JfSFlQX0tWTV9ESVNDT1ZFUl9JTVBMX1ZFUl9G
VU5DX0lELA0KPiArICAgICAwLCAmcmVzKTsNCj4gKyBpZiAocmVzLmEwICE9IFNNQ0NDX1JFVF9T
VUNDRVNTKQ0KPiArIHJldHVybjsNCj4gKw0KPiArIC8qIFZlcnNpb24gaW5mbyBpcyBpbiBsb3dl
ciAzMiBiaXRzIGFuZCBpcyBpbiBTTU1DQ0NfVkVSU0lPTiBmb3JtYXQgKi8NCj4gKyB2ZXIgPSBs
b3dlcl8zMl9iaXRzKHJlcy5hMSk7DQo+ICsgaWYgKFBTQ0lfVkVSU0lPTl9NQUpPUih2ZXIpICE9
IDEpIHsNCj4gKyBwcl93YXJuKCJVbnN1cHBvcnRlZCB0YXJnZXQgQ1BVIGltcGxlbWVudGF0aW9u
IHZlcnNpb24gdiVkLiVkXG4iLA0KPiArIFBTQ0lfVkVSU0lPTl9NQUpPUih2ZXIpLCBQU0NJX1ZF
UlNJT05fTUlOT1IodmVyKSk7DQo+ICsgcmV0dXJuOw0KPiArIH0NCj4gKw0KPiArIGlmICghcmVz
LmEyKSB7DQo+ICsgcHJfd2FybigiTm8gdGFyZ2V0IGltcGxlbWVudGF0aW9uIENQVXMgc3BlY2lm
aWVkXG4iKTsNCj4gKyByZXR1cm47DQo+ICsgfQ0KPiArDQo+ICsgbWF4X2NwdXMgPSByZXMuYTI7
DQo+ICsgdGFyZ2V0ID0gbWVtYmxvY2tfYWxsb2Moc2l6ZW9mKCp0YXJnZXQpICogbWF4X2NwdXMs
ICBfX2FsaWdub2ZfXygqdGFyZ2V0KSk7DQo+ICsgaWYgKCF0YXJnZXQpIHsNCj4gKyBwcl93YXJu
KCJOb3QgZW5vdWdoIG1lbW9yeSBmb3Igc3RydWN0IHRhcmdldF9pbXBsX2NwdVxuIik7DQo+ICsg
cmV0dXJuOw0KPiArIH0NCj4gKw0KPiArIGZvciAoaSA9IDA7IGkgPCBtYXhfY3B1czsgaSsrKSB7
DQo+ICsgYXJtX3NtY2NjXzFfMV9pbnZva2UoQVJNX1NNQ0NDX1ZFTkRPUl9IWVBfS1ZNX0RJU0NP
VkVSX0lNUExfQ1BVU19GVU5DX0lELA0KPiArICAgICBpLCAmcmVzKTsNCj4gKyBpZiAocmVzLmEw
ICE9IFNNQ0NDX1JFVF9TVUNDRVNTKSB7DQo+ICsgcHJfd2FybigiRGlzY292ZXJpbmcgdGFyZ2V0
IGltcGxlbWVudGF0aW9uIENQVXMgZmFpbGVkXG4iKTsNCj4gKyBnb3RvIG1lbV9mcmVlOw0KPiAr
IH0NCj4gKyB0YXJnZXRbaV0ubWlkciA9IHJlcy5hMTsNCj4gKyB0YXJnZXRbaV0ucmV2aWRyID0g
cmVzLmEyOw0KPiArIHRhcmdldFtpXS5haWRyID0gcmVzLmEzOw0KPiArIH07DQo+ICsNCj4gKyBp
ZiAoIWNwdV9lcnJhdGFfc2V0X3RhcmdldF9pbXBsKG1heF9jcHVzLCB0YXJnZXQpKSB7DQo+ICsg
cHJfd2FybigiRmFpbGVkIHRvIHNldCB0YXJnZXQgaW1wbGVtZW50YXRpb24gQ1BVc1xuIik7DQo+
ICsgZ290byBtZW1fZnJlZTsNCj4gKyB9DQo+ICsNCj4gKyBwcl9pbmZvKCJOdW1iZXIgb2YgdGFy
Z2V0IGltcGxlbWVudGF0aW9uIENQVXMgaXMgJWxsZFxuIiwgbWF4X2NwdXMpOw0KPiArIHJldHVy
bjsNCj4gKw0KPiArbWVtX2ZyZWU6DQo+ICsgbWVtYmxvY2tfZnJlZSh0YXJnZXQsIHNpemVvZigq
dGFyZ2V0KSAqIG1heF9jcHVzKTsNCj4gK30NCj4gLS0gDQo+IDIuNDcuMA0KPiANCj4gDQoNCg==
