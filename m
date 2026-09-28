Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD89848F002
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790587758; cv=fail; b=JJBnu5zAGrsQw6LTiCfm7JygcE5Wm5dM5oqenJWTLC3JydoYQISBqeIJayBWZCaMa4wY6j+U7qNbluWWWTUzTKS7wJ8lcPgZEaUm4akMPVde//uYewQo4BQ7LvFPrQ+FVCD/fVLKEmc13+ryPPmjEyKmXGjR8DexCepnymxvh5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790587758; c=relaxed/simple;
	bh=UQVwlLEBsgwIEGuc9mpYRX3Xh4x8Wfq33E6pBsmVH7c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hj/9vFAC2H1X0jj6dRPph4p4SsNJ+Ao9/CXxBqL7PqP01ADoP2B92QjMlSSGGnL+GeT/de7sWfhZ7jqzH9XRQA29rtk32WETr8LT6UU2Svs2ym4r0Ko0+sczDTydrp1ylwfbJvlB8I7TWcE0ueLrNUbZlxcgwyubcYOYYoNpSoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kZT4fmzI; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=w+K6Dze0; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kZT4fmzI";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="w+K6Dze0"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9KZ9f1142530;
	Mon, 28 Sep 2026 02:28:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=UQVwlLEBsgwIEGuc9mpYRX3Xh4x8Wfq33E6pBsmVH
	7c=; b=kZT4fmzIa06huVQNaFlzmZfl1m+3mCDwVlPdqvnPNe3W8FT/JDCQ2UT/j
	Or2dxwlsxPW0/x2v8mkNtqx20wy0Wkz8ZG4emmNEGDUea0gbhmsw1it5VCWLdbbC
	kD82qrOcI1t3IvHX76lKGOfgGoVfwd0jQ1BlghF3ibzMndsptQEXyna0MHYtMu3G
	YvnPZ4P1um+SAX/lIMRgbijDIIv4sI2jnlIkwfDSFo7Rlq3WPDcS2jmWmsI3gZ6+
	BECMWw8PCL44q5XEqPeOsq6CKpQyx25atnkYEf3Ecri6D80GmbG0mzfi8QBG8DeT
	g5TyEcv3aN88TIH0Tms/LdWTMqa0w==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020113.outbound.protection.outlook.com [52.101.56.113])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gxd4ek8jf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 02:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JnveoOXydjzP0Fbd6MHSwYGa3/Mn285bR4CZ7Xk7Wz4uyQZIqOKyVJ6vmTGVK3o/woSX7MCwvmFFokbQ/lXsSnydsQE3VfyTrJWbgNbAZZmjEPgW74C2OevVdgeYsRfFU7QdkeWzcYqnfMJDpY/wGJcC62Ee5lf3sw0Muq8yUj0rbux1XIaFw2QV+H6MToS3pf6NUTp6qHmp0NeQk0hQ6ZQkHq4bD14V7mzDLLUBkWC7WBp/VH2TtbzZSE82rfj66Og+ZH0a24QG5mSQKdn2n0biI4wNb8ZIF0omV6eisC0wNTkUNMDDKRjp5NkrsgQUj9OHnKXLxRASxOItg+zphA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQVwlLEBsgwIEGuc9mpYRX3Xh4x8Wfq33E6pBsmVH7c=;
 b=wsNZOxfg/o9PSC8EMWRB7fCMQ2FPNYocHlM3jhWICQMMhDnUfstWRPk6nkq6ZUwKqc8p9hZNIG6GcaDHQ0DxOtJCKHBJVBlW5oTn9VxHnOK7N/xHsEJ+p6nufA2RAGwEAokctvCUGTtQY3RbogvUH7PjCZKSCs8o/FmcGIkn+325YV0hc7Hg4grFQwsqDAUM+TxLhmWXr94ytRTq9F/j3TcPvZC33JraqRShEHiXkYVEvzc9t2ChFDKMaibXgE8lgANG+JVERgxN0GqrPtDjzjzQJ/dDxB8vsENnSCO9wIBjXBl/2yheddafS6QqcGPpKB/tBv7TnafKMD9jkisaEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQVwlLEBsgwIEGuc9mpYRX3Xh4x8Wfq33E6pBsmVH7c=;
 b=w+K6Dze0okm/3hG9bcZJOIm6I0ifixVBsZNdskJ9PqGg/ci63gUre59t2m4DKnZxSS0qRTZyAB7BnCpOdDaNVesMeyOWIPHtUkB+6XXq9lZ0aluxTcQpajQQbvbcWCz43Zx7HmK+A2ulnp2r0OYJHB0DwaD3N14jVek4/J21zYMfrUsqLm4MOg0hMlq6AKnPe7kTGOSM4H7hFR4YYcIfLe1oUmeIrlHGWmPfyjIQOE8OO/ivpWoW2ccyXKCy11vYDm80HPMi6zQJdiB83rPdfS/Mov7RhhYqmF5lsCToJm27787E9mh1yqd1Fq7rNK9ud9iZ0LQVhp8PF8A0kviHiA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM8PR02MB8215.namprd02.prod.outlook.com (2603:10b6:8:e::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.24; Mon, 28 Sep 2026 09:28:40 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 09:28:40 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@oss.qualcomm.com"
	<philmd@oss.qualcomm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com"
	<abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v9 14/26] target/arm/kvm: Implement SYSREG property setter
 and getter
Thread-Topic: [PATCH v9 14/26] target/arm/kvm: Implement SYSREG property
 setter and getter
Thread-Index: AQHdTyu/i5Mxl3yPLEWkLHfWXmw/fA==
Date: Mon, 28 Sep 2026 09:28:40 +0000
Message-ID: <ABBAB5A1-BD41-4D5C-9D09-DD1D7C50D0FB@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-15-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-15-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DM8PR02MB8215:EE_
x-ms-office365-filtering-correlation-id: 931dd929-b59f-4a1d-f0d9-08df1d42e20b
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|38070700021|4143699003|10067099003|56012099006|22082099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 Sv/B+ahuG5pf0eopt4LMADgAM9ahrqrnAwhsgHr2pPu5eRpe/QVOfDHnnwtSEyTwg+4lhdsN7K1K7tCO9UhrKCa3rSTu1cGF0FLFu8wF5RjZP9mfzLvZBtOvIL21AEfD/3mwItD25mkut7Z4d2/trXIyqLzy5ounMbiGYSR6dhOXGEiJVdJKeuqTlJGuP/i/JIngaJ26KxrP9ZObH0/rF7E+jaTQTWLc92AXJ78qi8AxI12qf3MRYv/5ju8ignyd8NQPxF4ChiNkyonItv3RZzGk56FSdLO10R8UVPhcpinSXfqIcI8Ck8hWbbeVzSCBIlILKxOM9if5s+Zn5gE5uVWHe8biQzBuZys9XS2rVecZqMQjVlKD3AVQ1rCtH2TuwC9Lush9a1MPFHhLHnmecLmqdLpvLgkPuFM0NAMsk2f2uY8vEOZt0EtpXXQgUKwrFHZtRothdcjYD4/QVw9oqs+H2Oqw7yugfPM9d6h74aBGqIEWZvNQnzBp/irVcJIAAVWbPh5lR4reURG8HbBZt6qikWbpdKqDZgBMqeitvOzDj3VRT+6tXYVemXmCOTcFmg3RqV+aelO1HHjrjcHntAhNsJdn9T9CYx+yab3IVcjex2E1+5mNEFD1bZYrlof4W4oGvhebG1rfR8F33QLPjMTQ7ESv1QrWbktIyqX9m1wDd9aaUn5v9/hlppkK1RFqpp3R2Xj158doD6Fez4rc9q8ulhCaS6A2L4FoPmswAPI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(38070700021)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Zk9kQmpId29tYW1xQkR1OHBaZkZPM1RrRXdQUndyZitERGF0dHFxZmdhazdV?=
 =?utf-8?B?ME1jblAxVFJ6Rkc4SGF5NTFuQW1DN2ZCbm9oeDRkZ0t0LzFMbnBUYTlZZWVF?=
 =?utf-8?B?b1ZLUEo2WVJGcW9hb1N2RXh0ajZ6MzRJNEpPeUlsaEFUajRzVlhrbnJ2blRL?=
 =?utf-8?B?QTFWMWlSOWJOOERBQ0h5a3ZRdXZHZ0pURVpPbDVnUG5IWUQvMS9TV1NlSDVt?=
 =?utf-8?B?bUJVcEEraWpGRVNadFRZRm41L3dGQ3JrSUl0cnhWcjZyWklFYkZUYzJGTmdO?=
 =?utf-8?B?OTdVNmo0TUNCeFF3elJJNXdRblhmTFRCRXEyRjNwdzZlNnNBbzhLNWFpeXF2?=
 =?utf-8?B?djdKRXlxWWpnN2wzOERFWjB6NHNGTmVPZXY2dGVPeGRRL3ZWUWRObDVCcTdo?=
 =?utf-8?B?RmwvbkFuVER0dUhmSENxUjU3NkNiSVNZL1Y0MHhnam1ZeG45dDVHaWdrVzNn?=
 =?utf-8?B?cSs3UDk3VFJXZjZwSDhwSzNxbyswdERYSFpqakZzSmcrUzl0eVZYMllXQkNE?=
 =?utf-8?B?SkV2TjRkdWc2UTdrVGgrSFNtTTZFejlVVDJKekRoYjdSdExvUjF2QkxxZmxC?=
 =?utf-8?B?Ym9iWmcwRW93VTR3SWE3aElmSlUvSm51bU5NazM5R1lGQnYraWlVNStva0lH?=
 =?utf-8?B?U3JmdWZLUDZUYjdtYkFYM0szY3lpZHkwcmQ3MXA5bmRsNXBJWVVtS3VXRDdp?=
 =?utf-8?B?VEVYb1daajRoejJGbDBLRDRmUkR0RHRNMjEza29zTEM1SCtCNlhCWnhXeSt0?=
 =?utf-8?B?Z0xZSmVlanM0MGpPbmZ2cTF1U1FWeHh3bURGSzBwakJvWEtSTS84T2l4em5z?=
 =?utf-8?B?RlU5VTVXWU9KOHBXUE5FRkxpaGdEUjVIdlZXeUVISXBpbC9jMUJuWFNhL1Fj?=
 =?utf-8?B?R1hPRTd1WXlrYVRXNUQzM1BzL1JXaDQvMjZUbTNjNjIwcDJHanhqZmYwb0tj?=
 =?utf-8?B?dGZHdjJZUWVrK1VZOWdXQmpZOVhINERLckFPVVdVVStqV1JCNnJ6aTgwZGJU?=
 =?utf-8?B?eG9oTTRqbUdab1JmRzN6ekxpSEo0T0EvTnZudTdVUjZOVFV5SFFtN2NrQ2N3?=
 =?utf-8?B?eG1DZDZMQTJKOXRtTDI1L2t2Y0svUnI3WHlZYitNWjdnTCtyZmQzRjRDUjVn?=
 =?utf-8?B?WW1GbEttbEZXVUV2QU8zVFlaaWt2TURlME1xSXVSdDNkVUhydEVJTFRlZHBK?=
 =?utf-8?B?cFhrTWJlUTRKUWNHbThBRjhxUFZwVG93Rm1YejhpV3M0a1p2OW9UcUNTem9a?=
 =?utf-8?B?am5KRDNYSGh5MFI1UVR1NnJqWWNUUnhlaTk3M2szUEFpKzVLOWNsNUJCMy9G?=
 =?utf-8?B?dGQrdnVoNm9hOWMzdUt0N2R6azEyYU1rTVg2V0dKcTRmNlltdzI3Y0FzcVB4?=
 =?utf-8?B?VlVOd0xKQWttRmZqLzFFTzJIaXA2bVRna0M2eGE5aDFod3U0a2hIZE1VYS9W?=
 =?utf-8?B?M0tpOVR1WmRKOGlJWENsNzZRemVnOEtrYWRXNGR6WkVVbE9Yam0rUWdCV2th?=
 =?utf-8?B?S09iQ2M4Q04rS0NFd25KeElqNy80eTJ1RFNzdXE3QjE3cStvOTJmbzQ5S1Rw?=
 =?utf-8?B?T1ZYbFFuMlR3cElvWEhxU0dwWEUvL3JFa25vMVZkNXgyM0JLVURSVnpKbFV0?=
 =?utf-8?B?WGtSUjNKYi9peGk4OWQrenl3TjgyTHJOc2wrVWRlWUVheFNNUE9oaGljSVZx?=
 =?utf-8?B?d1ZmbUo5SUJzb1BqNHFSZlFYZ2tXOFFPRTJKK21ZbGhoYnZSRElFWHNFSjNS?=
 =?utf-8?B?N1I3a3pMbE1GamlKaXJCS1RHNGlEa1p6eXBkbFZCemFiSUM3QjczRXVlNzdR?=
 =?utf-8?B?c0xLbkxqZ1RUMXpyZmRLTEVKY255Y3YxM0ZpdG0rN2J3R0owazI3TDBvUHMy?=
 =?utf-8?B?UTZCZVc4UmQ0NzkwcnBOc1NYbml2RzdES1gzS0JPYi96UnZ2TTRGNWZEcFoz?=
 =?utf-8?B?N1FOUE9vU01YK3FMQlRrM0xseEF4OWp3ZmVKekhTOEJsTTZMY3VYeEQ1V252?=
 =?utf-8?B?aktFeCtaeFlVQ0hvM0JmVjdVZzFBa3EzUHlmalpBWVZUU2wwbVZoM1MweWJ6?=
 =?utf-8?B?OEwrUnVCRksyZWZYdmo5S1p0VUcrMUxrNmpzU2o2WnZjZktacmcrN2p3bGdM?=
 =?utf-8?B?OENlb0tEbDNUNTJlZmswNmREaWpzcWZOcTdpcUhPdGl5dWJFb1JWdWRtMUhU?=
 =?utf-8?B?YWN2R3FVWFB3N3ZzeTNySWpuaG04MHBzdS92ZkQ4STZSSlllWVR0RE9UdDR0?=
 =?utf-8?B?SWV2dXc0MHFQTk5RVWRROEJ0UFZ5eVlweVpsQkphKzU3K3pLYkxoVllyUE1I?=
 =?utf-8?B?Y01ldCtocjRoeGMzdWtFVlZVcjZ2M1VGSDEwOWE5Q056cFBKSGk4Sjl6V2Yr?=
 =?utf-8?Q?PGyqD/zIojOeynH0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <512FFEDEFEDA4744B757304D73E2511E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	mOOqUPi/F4m+7UjZ6xX4yA/4K5ejOdLT9pcIZi/85dboqrZ/S9L/Xh4RCcAgOlb0ccwuw6TRtDJzELKReJvR8Jc6fDaReszmnslWIRXgnnsbAbTIiUS0K4IfNZc+Ykjz9hy4t+lSjLntJVT9s+uGTID3zogbQtsgSrwTqvhYmV+vlkVr8vo+x/ga84BZ5nNyro+yeUp/AAPJRCReDj0GQJg9eRPEeRA3GgIkhl+KrA91Rai22qSGOqUgzFlq46YSLIbG59mrtG83qS2L3TqCDCCi/u2aIeBjPfUlL7X1HPk38K44a4zP3zN0rm2OH6rJ+w/uXR2X78Aj6Y0IJZMgzw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931dd929-b59f-4a1d-f0d9-08df1d42e20b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 09:28:40.7361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MFMcNDWP0lt0mN5zffNSiMONPT585mghwkvsLuOcl/0ogwGQS9b1RvmaPjI453GKe+iqaLmue1bAuLVHwCKzZcfcbp8Su0N/L56drMciA8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8215
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDAzNiBTYWx0ZWRfX1Za0mwaj6dTE
 UgGR6CNJMwEVPFib6eY7fNGPaFD24aWMhR4+ZqKR+pbh8VyVUjMrkqTYgoAvpF4frs8fbA/fnOs
 /SCrdpkJlpGIcWmFJGH9958Wu6WM0FQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDAzNiBTYWx0ZWRfX8wLorB5asnHz
 VPB2W9h/6iP39tbMGIs3Mp06SBdaZYfiaMYvdpI443qdfEgtHGhxLcz9W+K9Bti0ywIUaznAfLY
 IjFTg8g+zbVUevjudhXKAr4j2jVmaNsdZJCr436YbggJPzICzZEM7yAuLfVdVhrcwEcz1R25lFw
 qwsCcPlcCyD+zZ10wQR52aywSXXa3YQf4rwG9gUEfsm2E94INQ854R2b0NI+hazbUQM2Lx2vEX2
 q4I9AHbID2vjInSxgbSzH56lH1TfmT6P3mJBv1HMfVBrKLBq/w6o+O4FEZJHdEUuhiReLFWyR6d
 UD8BAKogk5mGIGQow37RBwHX9uJoZ+d6RxD9uqHXWfXx8gK1241d7zzLE9mHTCMrW7rBOOIvUd5
 dcKnrFYQAQ6Vk77jZrFjf7b9vKkOqkdgPkEB5SOEoEDfxxMBSzW1p5tfQsecVBklXLFqcavd6H+
 JVJXXwBqCfCVAaux32w==
X-Authority-Analysis: v=2.4 cv=SqMFe/O0 c=1 sm=1 tr=0 ts=6aba334d cx=c_pps
 a=gm+t6+/57aVGIJ5RQ2SxIg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=64Cc0HZtAAAA:8
 a=20KFwNOVAAAA:8 a=iuMDWB40HM3El7G4z6oA:9 a=lqcHg5cX4UMA:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZzPR3c4-V-jPjEMhUXE9VADvZEhCqlAQ
X-Proofpoint-GUID: ZzPR3c4-V-jPjEMhUXE9VADvZEhCqlAQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gV2hlbiB0aGUgc2V0dGVyIGlz
IGNhbGxlZCwgdGhlIGZpbmFsIHZjcHUgaXMgbm90IGNyZWF0ZWQgeWV0Lg0KPiBBcHBseWluZyB0
aGUgb3ZlcnJpZGUgb24gdmNwdS5pc2FyIGluaXRpYWxpemVkIHdpdGggdGhlIG1heCBzY3JhdGNo
DQo+IHZjcHUgd291bGQgbm90IGJlIGNvcnJlY3QgYmVjYXVzZSB0aGUgZmluYWwgdmNwdSBtYXkg
aGF2ZSBzb21lIGZlYXR1cmVzDQo+IHR1cm5lZCBvZmYgKGZvciBpbnN0YW5jZSB2aXJ0dWFsaXph
dGlvbikgd2hpbGUgdGhlIHNjcmF0Y2ggdmNwdQ0KPiBmZWF0dXJlcyBpdC4gU28gd2UgbmVlZCB0
byBwb3N0cG9uZSB0aGUgYWN0dWFsIG92ZXJyaWRlIHVudGlsIHRoZQ0KPiBmaW5hbCB2Y3B1IGhh
cyBiZWVuIGluaXRpYWxpemVkLg0KPiANCj4gSW4gdGVybXMgb2YgaW5wdXQgdmFsdWUgdmFsaWRh
dGlvbiB3aGF0IGNhbiBiZSBkb25lIG5vdyBpcyBjaGVja2luZw0KPiBhZ2FpbnN0IGZpZWxkIGxl
bmd0aCBhbmQgYXJjaCBlbnVtIHZhbHVlIGlmIGFueS4NCj4gDQo+IElmIHRoaXMgc3VjY2VlZHMs
IHRoZSBmaWVsZCB2YWx1ZSBpcyBhZGRlZCBpbiB0aGUgaGFzaCB0YWJsZSB0byBiZQ0KPiB3cml0
dGVuIGxhdGVyIG9uIG9uY2UgdGhlIGZpbmFsIHZjcHUgaGFzIGJlZW4gY3JlYXRlZA0KPiANCj4g
V2l0aCByZWdhcmRzIHRvIHRoZSBnZXR0ZXIsIGlmIHRoZSBzeXNyZWcgcHJvcCB3YXMgc2V0LCB3
ZSByZXR1cm4gdGhlDQo+IHNldCB2YWx1ZSwgb3RoZXJ3aXNlLCB3ZSByZXR1cm4gdGhlIHZhbHVl
IGluIGNwdS0+aXNhci5pZHJlZ3NbXS4NCj4gDQpIaSBFcmljLA0KDQpQbGVhc2UgbWVudGlvbiB0
aGF0IHRoZSBjcHJlZyBvdmVycmlkZSBoYXBwZW5zIGluIGxhdGVyIGNvbW1pdHMuDQoNClNpZ25l
ZC1vZmYtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tIDxtYWlsdG86
a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPj4NCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8
ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiAtLS0NCj4gdGFyZ2V0L2FybS9jcHUuaCB8ICAyICsr
DQo+IHRhcmdldC9hcm0vY3B1LmMgfCAgNSArKy0tDQo+IHRhcmdldC9hcm0va3ZtLmMgfCA2NSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gMyBmaWxl
cyBjaGFuZ2VkLCA2OCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL3RhcmdldC9hcm0vY3B1LmggYi90YXJnZXQvYXJtL2NwdS5oDQo+IGluZGV4IGUzZjkz
MWRiYTIuLjliYmQ0MmRkMmIgMTAwNjQ0DQo+IC0tLSBhL3RhcmdldC9hcm0vY3B1LmgNCj4gKysr
IGIvdGFyZ2V0L2FybS9jcHUuaA0KPiBAQCAtOTUyLDYgKzk1Miw4IEBAIHN0cnVjdCBBcmNoQ1BV
IHsNCj4gICAgIHVpbnQ2NF90ICpjcHJlZ192bXN0YXRlX3ZhbHVlczsNCj4gICAgIGludDMyX3Qg
Y3ByZWdfdm1zdGF0ZV9hcnJheV9sZW47DQo+IA0KPiArICAgIEdIYXNoVGFibGUgKnN5c3JlZ19w
cm9wczsNCj4gKw0KPiAgICAgRHluYW1pY0dEQkZlYXR1cmVJbmZvIGR5bl9zeXNyZWdfZmVhdHVy
ZTsNCj4gICAgIER5bmFtaWNHREJGZWF0dXJlSW5mbyBkeW5fc3ZlcmVnX2ZlYXR1cmU7DQo+ICAg
ICBEeW5hbWljR0RCRmVhdHVyZUluZm8gZHluX3NtZXJlZ19mZWF0dXJlOw0KPiBkaWZmIC0tZ2l0
IGEvdGFyZ2V0L2FybS9jcHUuYyBiL3RhcmdldC9hcm0vY3B1LmMNCj4gaW5kZXggNzdhYTc4ZjAw
ZS4uOTE3ZjcwOWNiNCAxMDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS9jcHUuYw0KPiArKysgYi90
YXJnZXQvYXJtL2NwdS5jDQo+IEBAIC0xMjM2LDggKzEyMzYsOCBAQCBzdGF0aWMgdm9pZCBhcm1f
Y3B1X2luaXRmbihPYmplY3QgKm9iaikNCj4gew0KPiAgICAgQVJNQ1BVICpjcHUgPSBBUk1fQ1BV
KG9iaik7DQo+IA0KPiAtICAgIGNwdS0+Y3BfcmVncyA9IGdfaGFzaF90YWJsZV9uZXdfZnVsbChn
X2RpcmVjdF9oYXNoLCBnX2RpcmVjdF9lcXVhbCwNCj4gLSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgTlVMTCwgZ19mcmVlKTsNCj4gKyAgICBjcHUtPmNwX3JlZ3MgPSBn
X2hhc2hfdGFibGVfbmV3KGdfZGlyZWN0X2hhc2gsIGdfZGlyZWN0X2VxdWFsKTsNCj4gKyAgICBj
cHUtPnN5c3JlZ19wcm9wcyA9IGdfaGFzaF90YWJsZV9uZXcoZ19kaXJlY3RfaGFzaCwgZ19kaXJl
Y3RfZXF1YWwpOw0KPiANCj4gICAgIFFMSVNUX0lOSVQoJmNwdS0+cHJlX2VsX2NoYW5nZV9ob29r
cyk7DQo+ICAgICBRTElTVF9JTklUKCZjcHUtPmVsX2NoYW5nZV9ob29rcyk7DQo+IEBAIC0xNzI1
LDYgKzE3MjUsNyBAQCBzdGF0aWMgdm9pZCBhcm1fY3B1X2ZpbmFsaXplZm4oT2JqZWN0ICpvYmop
DQo+ICAgICBBUk1DUFJlZ01pZ1RvbGVyYW5jZSAqdCwgKm47DQo+IA0KPiAgICAgZ19oYXNoX3Rh
YmxlX2Rlc3Ryb3koY3B1LT5jcF9yZWdzKTsNCj4gKyAgICBnX2hhc2hfdGFibGVfZGVzdHJveShj
cHUtPnN5c3JlZ19wcm9wcyk7DQo+IA0KPiAgICAgUUxJU1RfRk9SRUFDSF9TQUZFKGhvb2ssICZj
cHUtPnByZV9lbF9jaGFuZ2VfaG9va3MsIG5vZGUsIG5leHQpIHsNCj4gICAgICAgICBRTElTVF9S
RU1PVkUoaG9vaywgbm9kZSk7DQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFy
Z2V0L2FybS9rdm0uYw0KPiBpbmRleCAzNDE1NDIyNzlkLi5jZGMzNzc5MzIxIDEwMDY0NA0KPiAt
LS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4gQEAgLTM0
MCwxOCArMzQwLDc5IEBAIHN0YXRpYyBBUk02NFN5c1JlZ0ZpZWxkICpnZXRfZmllbGQoaW50IGks
IEFSTTY0U3lzUmVnICpyZWcpDQo+ICAgICByZXR1cm4gTlVMTDsNCj4gfQ0KPiANCj4gKyNkZWZp
bmUgTUFLRV9JRFJFR19LRVkocmVnX2lkeCwgZmllbGRfc2hpZnQpIFwNCj4gKyAgICAoKCh1aW50
NjRfdCkocmVnX2lkeCkgPDwgOCkgfCAoKHVpbnQ2NF90KShmaWVsZF9zaGlmdCkgJiAweEZGKSkN
Cj4gKw0KDQpNYXliZSwgSURSRUdfRklFTERfS0VZKCk/DQoNCldhcm0gUmVnYXJkcywNCktodXNo
aXQNCj4gc3RhdGljIHZvaWQgc2V0X3N5c3JlZ19wcm9wKE9iamVjdCAqb2JqLCBWaXNpdG9yICp2
LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqbmFtZSwgdm9pZCAq
b3BhcXVlLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRXJyb3IgKiplcnJwKQ0KPiB7
DQo+IC0gICAgZXJyb3Jfc2V0ZyhlcnJwLCAiJXMgc2V0dGVyIG5vdCB5ZXQgaW1wbGVtZW50ZWQi
LCBuYW1lKTsNCj4gKyAgICBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCA9IChBUk02NFN5c1JlZ0Zp
ZWxkICopb3BhcXVlOw0KPiArICAgIEFSTUNQVSAqY3B1ID0gQVJNX0NQVShvYmopOw0KPiArICAg
IGludCBpbmRleCA9IGZpZWxkLT5pbmRleDsNCj4gKyAgICBpbnQgbG93ZXIgPSBmaWVsZC0+c2hp
ZnQ7DQo+ICsgICAgaW50IGxlbmd0aCA9IGZpZWxkLT5sZW5ndGg7DQo+ICsgICAgdWludDY0X3Qg
a2V5LCB2YWx1ZTsNCj4gKw0KPiArICAgIGlmICghdmlzaXRfdHlwZV91aW50NjQodiwgbmFtZSwg
JnZhbHVlLCBlcnJwKSkgew0KPiArICAgICAgICByZXR1cm47DQo+ICsgICAgfQ0KPiArDQo+ICsg
ICAgaWYgKGxlbmd0aCA8IDY0ICYmIHZhbHVlID4gKCgxIDw8IGxlbmd0aCkgLSAxKSkgew0KPiAr
ICAgICAgICBlcnJvcl9zZXRnKGVycnAsDQo+ICsgICAgICAgICAgICAgICAgICAgImlkcmVnICVz
IHNldCB2YWx1ZSAoMHglbHgpIGV4Y2VlZHMgbGVuZ3RoIG9mIGZpZWxkICglZCkhIiwNCj4gKyAg
ICAgICAgICAgICAgICAgICBuYW1lLCB2YWx1ZSwgbGVuZ3RoKTsNCj4gKyAgICAgICAgcmV0dXJu
Ow0KPiArICAgIH0NCj4gKw0KPiArICAgIGlmIChmaWVsZC0+YXJjaF92YWxzKSB7DQo+ICsgICAg
ICAgIC8qIHRoaXMgZmllbGQgaGFzIHNvbWUgZW51bSB2YWx1ZXMgKi8NCj4gKyAgICAgICAgZm9y
IChpbnQgaSA9IDA7IGkgPCBmaWVsZC0+YXJjaF92YWxzX2NvdW50OyBpKyspIHsNCj4gKyAgICAg
ICAgICAgIGlmICh2YWx1ZSA9PSBmaWVsZC0+YXJjaF92YWxzW2ldKSB7DQo+ICsgICAgICAgICAg
ICAgICAgZ290byB2YWxpZDsNCj4gKyAgICAgICAgICAgIH0NCj4gKyAgICAgICAgfQ0KPiArICAg
ICAgICBlcnJvcl9zZXRnKGVycnAsDQo+ICsgICAgICAgICAgICAgICAgICAgImlkcmVnICVzIHNl
dCB2YWx1ZSAoMHglbHgpIGRvZXMgbm90IG1hdGNoIGFueSAiDQo+ICsgICAgICAgICAgICAgICAg
ICAgImFyY2ggdmFsaWQgZW51bSB2YWx1ZSIsIG5hbWUsIHZhbHVlKTsNCj4gKyAgICAgICAgcmV0
dXJuOw0KPiArICAgIH0NCj4gKw0KPiArdmFsaWQ6DQo+ICsNCj4gKyAgICBrZXkgPSBNQUtFX0lE
UkVHX0tFWShpbmRleCwgbG93ZXIpOw0KPiArICAgIGdfaGFzaF90YWJsZV9pbnNlcnQoY3B1LT5z
eXNyZWdfcHJvcHMsIEdVSU5UX1RPX1BPSU5URVIoa2V5KSwNCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgR1VJTlRfVE9fUE9JTlRFUih2YWx1ZSkpOw0KPiB9DQo+IA0KPiBzdGF0aWMgdm9pZCBn
ZXRfc3lzcmVnX3Byb3AoT2JqZWN0ICpvYmosIFZpc2l0b3IgKnYsDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBjb25zdCBjaGFyICpuYW1lLCB2b2lkICpvcGFxdWUsDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBFcnJvciAqKmVycnApDQo+IHsNCj4gLSAgICBlcnJvcl9zZXRn
KGVycnAsICIlcyBnZXR0ZXIgbm90IHlldCBpbXBsZW1lbnRlZCIsIG5hbWUpOw0KPiArICAgIEFS
TTY0U3lzUmVnRmllbGQgKmZpZWxkID0gKEFSTTY0U3lzUmVnRmllbGQgKilvcGFxdWU7DQo+ICsg
ICAgQVJNQ1BVICpjcHUgPSBBUk1fQ1BVKG9iaik7DQo+ICsgICAgaW50IGluZGV4ID0gZmllbGQt
PmluZGV4Ow0KPiArICAgIGludCBsb3dlciA9IGZpZWxkLT5zaGlmdDsNCj4gKyAgICBpbnQgbGVu
Z3RoID0gZmllbGQtPmxlbmd0aDsNCj4gKyAgICBncG9pbnRlciB2YWx1ZV9wdHI7DQo+ICsgICAg
dWludDY0X3QgdmFsdWU7DQo+ICsgICAgdWludDY0X3Qga2V5ID0gTUFLRV9JRFJFR19LRVkoaW5k
ZXgsIGxvd2VyKTsNCj4gKyAgICBnYm9vbGVhbiBleGlzdHM7DQo+ICsNCj4gKyAgICBleGlzdHMg
PSBnX2hhc2hfdGFibGVfbG9va3VwX2V4dGVuZGVkKGNwdS0+c3lzcmVnX3Byb3BzLA0KPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgR1VJTlRfVE9fUE9JTlRFUihr
ZXkpLCBOVUxMLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
JnZhbHVlX3B0cik7DQo+ICsgICAgaWYgKGV4aXN0cykgew0KPiArICAgICAgICB2YWx1ZSA9IEdQ
T0lOVEVSX1RPX1VJTlQodmFsdWVfcHRyKTsNCj4gKyAgICB9IGVsc2Ugew0KPiArICAgICAgICB1
aW50NjRfdCBtYXNrID0gTUFLRV82NEJJVF9NQVNLKGxvd2VyLCBsZW5ndGgpOw0KPiArICAgICAg
ICB1aW50NjRfdCAqaWRyZWdzID0gY3B1LT5pc2FyLmlkcmVnczsNCj4gKw0KPiArICAgICAgICB2
YWx1ZSA9IChpZHJlZ3NbaW5kZXhdICYgbWFzaykgPj4gbG93ZXI7DQo+ICsgICAgfQ0KPiArDQo+
ICsgICAgdmlzaXRfdHlwZV91aW50NjQodiwgbmFtZSwgJnZhbHVlLCBlcnJwKTsNCj4gKyAgICB0
cmFjZV9nZXRfc3lzcmVnX3Byb3AobmFtZSwgdmFsdWUpOw0KPiB9DQo+IA0KPiAvKg0KPiAtLSAN
Cj4gMi41My4wDQo+IA0KDQo=
