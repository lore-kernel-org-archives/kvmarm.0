Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D7F364950
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779893248; cv=fail; b=AKnhGhB1FdamWih22IcDWoYN1QSbJ4ot+hBq7QGwHZTCTW+Z58CVnWRTC8Rh8fMiQwrVTKn34OB2jl/1ZDHGU2iA/40mXIpPLvnzWwHZKtQW8Tr2fUaIPWGEodhxqkAmW2ir3/RMYiMrL21nDFZoisER16kAix/xvM7/ftGKpjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779893248; c=relaxed/simple;
	bh=sr73F1QcP3VbMeJ2/lVY5AG70iLa9BZXqfG1eptVbKI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TcOHKKu3pUcSJP2jGs9fLeldIwb0FswcOt1ndHu5jYm5nBt4Wwolx/ETvKpuXDdRlViH3gfD02vNyp0oBUyryfWEjAzl7737AywZA4PaaY40+6fo7328UjTQTP/JTx6E4DWMiSOCIlhIx9bozFwBN1A94n4fnJe7J+JyKcYbgRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=1t1WWG8I; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tIAzR0eW; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="1t1WWG8I";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tIAzR0eW"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCs3iV2619691;
	Wed, 27 May 2026 07:46:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=sr73F1QcP3VbMeJ2/lVY5AG70iLa9BZXqfG1eptVb
	KI=; b=1t1WWG8IMw/V8o6sBDI6blyyenMrZC3xjLaYNvkJWLa9koRjQ1HP07f78
	b4SJ3BdJAUn6xRLVyUbZnyhxc90qOUn1dH4aV7fi6iaweVrHvsxvF/vGVXL+nIf4
	ftRKAwjiIg0lALVgFbgiL71pawtzJ3H/StfSIwh7Ldf3xtq+QNbeQAtpQhHpNJCe
	fdr8oqAKCuuuH6V547qH34xRwuMuV7jgzcgc6ScAyL03WSp0czMq2A2NqgUeaqW/
	wFpVhoLyMKg7Y4Hg6hn+Zwud+GVRX6U3OetgT7enJj9Z5NRat3Kn2Q09R2q+SlJ+
	WVlggvieiNsnelqCik8FieufsY0Iw==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022093.outbound.protection.outlook.com [40.107.209.93])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4edhy3t8b8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 07:46:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cKzOe0Dct3hszX6R7YRlmIV/RU0U9oEOFMyXsTeCmouzOpE0WUcb2B+uVfR4ukKTZcowQ476b/GX/o/fVKxJBBLaXZ1UTj9XhaRWQuB7pAe50LklXSh6Q+wIjwMERYiRii0UACKXMF+js2u1Oup3JZ4wFGEknAY0GLwiqRNMwybIZUcO2CdLO+GWCqTs5U8tZ+VCwg+q/AsiG3mLf/+izWJMN3PDIpAZv7/DJ+z15l/xizK8t5RWCLqrciru9ffSPPpehyxO4t5dKS09YcBNmMpw6bbBIVwuagA6FY2z4qVfKBRu7SKWP+oaW9S94n6sd3rGLeGyN70vjMd9mdUIdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sr73F1QcP3VbMeJ2/lVY5AG70iLa9BZXqfG1eptVbKI=;
 b=OMuV7j2rXQzdoBV4PegNisQ8oUQEORhHjaqWKrohx1hvBJSLrKKT7Tfra2lvmFmhgR24JekZV5kej1n3hiriaiQK8CXawDJZGuFC/1HBtlHzDEIQxcUzZqFP49N6S1aC8wVNlk6fzMFnkbTSnrufiKcxqXLGzFDyUbPqZqR30obYUGXLVOCfsMT59K6z4wxfsp5QcUoOVBTAlRWoqlABuUBGbTSSPftIE/Qns5co0KNS9myxWHPS0bgWkVEw3ktCPjaBkAskC3bd3o3KkmrGXVyRulV4q9qAelaiIkoLL47GlGro0IBde78ak4xZL66fZxKP+c/SrQezu6z3vl+UcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sr73F1QcP3VbMeJ2/lVY5AG70iLa9BZXqfG1eptVbKI=;
 b=tIAzR0eWDx8Fpu+zCVYR/dAjFPRyPuQkzRCJ+WEB8AWvdHhECF3yKVZz+EgGDDApa2TWjsQj+cQP/ncXeZ9TkMmIuoKzXyCgR/g0gIPcS/Czw2s22XIKmUcXSeGRHCS/Eg9ugUbH4EPZ1tkmQfsw7fC1pVh6pVHk3iCNhuZ9kTvE4rdyxWMoHh8dP0v1doau64CpWkS4fLpqiVw9eHCAFMbwD9NJKNNqFsBQ+DxrZ4szoclO7MPgq6VN5hsjXmCwNR+A7x2U2nCdJVhrcEpYzougzC/1zL6/W/kqGIWzKtGM3Zszq2zNzdH2VO+bf/1s1zVjZA39OCDQ9UV2Rmxsyg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB10966.namprd02.prod.outlook.com (2603:10b6:8:298::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Wed, 27 May
 2026 14:46:41 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 14:46:41 +0000
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
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v5 15/18] target/arm/kvm: Ignore some writable bits that
 shouldn't be
Thread-Topic: [PATCH v5 15/18] target/arm/kvm: Ignore some writable bits that
 shouldn't be
Thread-Index: AQHc55O/x+/NiUinyE2TjkVGnlGvpbYiAA6A
Date: Wed, 27 May 2026 14:46:41 +0000
Message-ID: <E5402D74-AE00-4088-801C-C87A749E17C9@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-16-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-16-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB10966:EE_
x-ms-office365-filtering-correlation-id: 9df33f1e-a9ca-4eb1-2e06-08debbfec3f0
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|22082099003|18002099003|4143699003|56012099006;
x-microsoft-antispam-message-info:
 KBCrFC9smtX9q0ngyG/CeDM+R5nxie4OgWNrcUp57FcCugTkztpZELhBQBQQ8NrF/61pVH69bUyAmYHkQqIjgNiF2aGOqo0Flx1sP+t4oed2x6DTOwch3cD5h+IK2oEsDBY3c8bgeD9XzpFfEKQoAp0r2rmq6VWeJt9Y1vvzbxD0L17akCYHt55VPD7UTz/zP1e8VxupRpJL8TxqEQAe+spEZ+2PjVqESbODnLu9s2wTZe6NbL9xcHQpQeQ0yzv6h98f27r1YlXVm+IgUgzpNW896xv2rr3KBu6iAuulFj5ZrZq9ES7pp0qv3gyQ7uQXiyTUgfBrQLskY4h12ewyPKH74Cao5LMHZpVwWastGSJGpz/5/0V8wwn02cfuDHWQpRz4fGO3yDH6FB7YzvsLLR0vWIJRurn1VDKoXQDWJshRTQMmhLbISoGXkbZBQSwWWPuMkzlLmZ9uyVctCdlta82Te2jM6dbGjwNI6N19a0Eio4dpY3o1EHKe81r+G104116QqRhwl4m0sDviOmPj+qLKdIMaY9tq8NvUr940yzGujvuiQdFDc8+b4F9lKXXw0Y+aHjQh0EQxTk2bZuwjvf7bo+4Xb/yd1WVatdu/Bw8NHK8hXtB48KS79FLNefMAxkHIGdnxEPrCMuTijEcIA9GPYDdqSAR3QN4ZjeC5Rvn75RuoiLzDaty/tvFf6O297psTTTDJK2U/MAf7k1+AazsliG1dkmvZ/9oKIZNiuNjvuYzhA8vPQg+YE+JtvXoS
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(22082099003)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U3lTM0twak1rUEllZGVLQlBYb09jOExscklsK3RwSjhXb3ArTGJKaFVlTVdk?=
 =?utf-8?B?OEd5QWhKK1N6ZlFUeEZETkxzNGpTSWwyN1hjdC9jUXVPVWl1K3F3OEVnY0Vh?=
 =?utf-8?B?N3UvMDRLL3RrNGhwMWVpMkJHNVhNc1FsOGhYVXBHWHorUTJSYTdubVFJTWxx?=
 =?utf-8?B?VFJIWGhnYmgxc3FFRnpiYUtUMHBjMGw2anlyeitJb2xXY1dPaHNUVHNydmNy?=
 =?utf-8?B?MEl1L0tiUXpVUWROeFFVekF4Z2pxeVJVaDNCRFBaS2t4aWN6Q1VzQ21EdEti?=
 =?utf-8?B?YmNESWtBNEFUY2p4bEVwS3ZiSGhhQ1BQRHl4L0Z3M2J6dk5HUVdobHI5L2Rx?=
 =?utf-8?B?Wktub2NCbFZqdmVpcXk2ZWlNbkJBM3hQbm4wbjBqWmtYV01wMmd3L1VpaE03?=
 =?utf-8?B?SHF6K21LQm5wT1BSYXZFYXhaR2VMK2loVGFQSFFvUStRcUphdFNaQmVjVzdr?=
 =?utf-8?B?SHlDQTVuU3hudkpWbmZwdVVuUEkwQTlBV0tPT2JWSzJ4N3dHaFdWVFZpNWdB?=
 =?utf-8?B?b2hNcnlvOFBsM2lwREw3elFkRlVPZmhMRHlYQVgvclB5ZUQ5TjNOMmFQejhI?=
 =?utf-8?B?aWRsVHVDWXZBTmFjeElhd0NvcytaY1ZCQ1V5STdScWVPay9XdW42QXR2S1Z3?=
 =?utf-8?B?SU9pYmQrTm9rY0ZYbFp3SFllUEtERGUrUWNma1hQaER0MEhVSFZ2VHVRMWp1?=
 =?utf-8?B?MnZiaUFsbktsaldBby94WDhQeGpxc2l4SWFYMjJpeE44RDVuTVRpYXRYalR1?=
 =?utf-8?B?VTlQakwyT2NrYUZrWW5yWnhVRlM1NEtNL1FTK05RbGtNaU1tOXdld2x5RExx?=
 =?utf-8?B?S0NhN3orUXUwV0pYeHljdlhNbXlzRzJ5Z0RLVzRISjhDMjZqWElGOXlpYmd5?=
 =?utf-8?B?cjFaa1dpNEZGTFNwR0hDV3RjN1FiWUcxV3FPZm01UFV2QzAvRmVKT21HZjY3?=
 =?utf-8?B?eGpHM1VMMmE4ZjRHVnNOemtaNWQ5YTZUNC9zY0hiQXUyQm5YdG1EUEhRYk9F?=
 =?utf-8?B?enM1NFVSQkpINVBqd3IzSUhXWnM2ZVRuRWJoaVJyRXNhN2NzZStudmpVSFF2?=
 =?utf-8?B?NTQ2ZEVKUFhzd3Nnc3BseDJFa3ZtQ1c0Nm5HUUtPUlU3TXkydjJDVlZTUmJl?=
 =?utf-8?B?bmd0Z2NsdzVucVhZcWNXSWNIT0s1Mm03cjNjVlBQSnJNNDE3QVJDSk0wMFhR?=
 =?utf-8?B?a1FWTHdvc0hsSUhQdFhiTjNaRjM5YWZyVEJZdjFVaTY5RTBlcXRrZ2tVVzNS?=
 =?utf-8?B?RkFJZFhRUFJYNDVwM00zdUxxTkJTbXdNMFB5RVVQNytHV2o4YkxTd0UyN3Vz?=
 =?utf-8?B?eDgyaXhrRWE5a2RWOXNuMTRqRDROQ0YyMVBkS0JKN3VGYjZmOE1oQTQrVVFi?=
 =?utf-8?B?eFM4YjNDamlicXBXZFZPczMxZUpwUFJ3dVhROWFPMGo5YzJsdWoyQmVhNGcy?=
 =?utf-8?B?M2F3TzBoU3l2MFNLazZXNkNaVEF1N29OZUVoZDE4Y0lCWWxId0p2Qm5DTk10?=
 =?utf-8?B?REVLOEZUWlg0ZkNkY1dhTzVxZjRQN0lmaDFZdjdwTjl2NHl5eGJrd1ZsVXd6?=
 =?utf-8?B?UEhZQWpJV0tGSFVTdWFkeFVvQTNFd01xRmt2Y01VWFBTRHV6bnlrVjFMSE94?=
 =?utf-8?B?TE5xdVBCR2N4Z0tBcm84RDdhUy9rdUZhcUpDSDFVbzcwN3BBd0JubEFPZG5i?=
 =?utf-8?B?TkZYRnZZWGZTcjU1Si8ycWxqZFhRbC9ud1pCa1pNUXZkNG1lTlZBaTY2cmlk?=
 =?utf-8?B?cHo0QWcxc2NWY3FabVZuMlM5Rml5Ty9MZ1RXTHNWeG5neCtwd3lKUGhzMjJm?=
 =?utf-8?B?dzRnRjRzOFRjcm13ZUpxVzRJOXhCWmtBY0tUR3prZUUrditiQnh3dmIxcnR6?=
 =?utf-8?B?RVpvR1pUWm5mcjJKakVpTmJTM2QzRjVwM24xUUZOR0xFR05mKzRtRGM3SEE5?=
 =?utf-8?B?ajVNdGV6aHdRcDFUUEZ3eHJWdlpKYm1DSHhFOXFvZkpDZkRRUnpFR2ZGNHJM?=
 =?utf-8?B?WjMzTnM3ZlJRbkJ4ZkVDcXFOYjQveWxGZzRPaUpNM1dZMnBNT2RvS09OZU1i?=
 =?utf-8?B?UlY5QXEydGhqMlhVdHM3QUx2N2psQXFOeGlMRWgyVWg3bXkveFBiVTFSOE1P?=
 =?utf-8?B?TlNKanMxMUllMlBxZGFQWHdGay9MWVZEN2xrR0MzUXZmR3AvOUhLMFJFT2Vj?=
 =?utf-8?B?dWVVRTRQeWl1aVAwUUlLZ2k2YTFkVGJoZHZDQW9xbWJiTzc0ZEd3S1BDRFVY?=
 =?utf-8?B?cm42Z011c05hREpJaVNsaGtteVZHVmpvc0N5UmtxYkdyV0NFU01HekJLbXp0?=
 =?utf-8?B?M2M3LzhKbEJNYVlWVmpscVduVnV2ZVpFZk9kQUk4WlJiUzh6UmhGc2MxOHVQ?=
 =?utf-8?Q?xHZJYxbJSIGUi8rI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E63BF4E5D621543BDAE8E1C728CE927@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	OK4Hc3JAC/Ohj90k7sr7R1KxJQVqijk7EgO5Dobo4LMpRSLktVIWoHpa/WcAAG1iPQ/w/QPv6VkDII0F7C2nnmBRDmQkzGMjO34IzZkvZ6x+MUR0DFOIm3qMkUbst94ZtnzQSn6s45bH7r/B+HNgwxIDSLvmaGlgJM3lyXf+xoZqDuqfI9mfaud4/8djf8FE3cAqVjH1WjBTW4Oa560S7+wohhsfgY8DDS+ZmtOpHp93S+5rWofvXh0b+NNr2kNT5gDpfe21zgrpU728ufyU4SSyzSr2B/WGe0d27mCkMzCqKRvQXjyLlCI0cJEk4mOfporb9i6WaGPny/koDWZUuA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df33f1e-a9ca-4eb1-2e06-08debbfec3f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 14:46:41.6063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51+xh87L9YRsMWoESWSIGsTJzCH+ETYWAGYIU9YbafMZx72hwp5LFFo4b5T8VMF7wrO6+isNNXGCCCduXhqJ8V9ebXFw8ZhnZ0Y0Xdqdm0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10966
X-Proofpoint-ORIG-GUID: AyjwgjREX2Y5zZicNy62POMoAtk3IXHp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE0NiBTYWx0ZWRfX3iCIwldcCkp5
 /IH+OJBhvJb/sJLL0ygBdYvWY+MoX3tQhP9SUzXhnwEklgu1DAQhk1jExBl/o1nyzz+W1xXh6Pp
 3au05qYngzu4eyTjlml3jJ65QFuA65Qd+6acdh4GfZ/ExGI0W85fPSvtINqa4yiR/m0c9S6yIrd
 HZj1ObWRDrqsHZ0vk+EDdc/wfagr6Ct+eu7WwNrHMIggJwjBobWbpa8fBgzsBtFiWBlU+mnFyBw
 Y9YLa3UBaKCy4jcPmwvFoa6+O7uxeq4JECnw8jidiclkWdIpCgxmYVnOGrbyE7L9FY7H/37ArCQ
 MuiWhwKDPFWsYHRTxB3xbITYP1VuB9PKRpRxjgxPCE2DQMy55L/0TUiS7HXr8JdTEbLjcuAmhwy
 PhsCI1bPrbc8qffjxo9DVZ50MqE/GZ0XEdVRsYiJS0jTur0FYjgfW5AJlkbEsU89tHmTQ+nZG4C
 cMyowajz10Kx6Xoop/Q==
X-Proofpoint-GUID: AyjwgjREX2Y5zZicNy62POMoAtk3IXHp
X-Authority-Analysis: v=2.4 cv=f7l4wuyM c=1 sm=1 tr=0 ts=6a1703d4 cx=c_pps
 a=+aoWgcdf8QL7nCWWbKbTBg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=FV8Pc82kc2I7x5fEPBIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgTWF5IDIwMjYsIGF0IDY6NTfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IA0KPiBLVk0gY3VycmVudGx5IHJlcG9ydHMgc29t
ZSBiaXRzIGFzIHdyaXRhYmxlIHdoZXJlYXMgdGhleSBhcmUNCj4gUkVTMCBvciBSQVouIFRoaXMg
aXMgZGV0ZWN0ZWQgYmVjYXVzZSB0aGUgY29kZSBhdHRlbXB0cyB0bw0KPiBtYXRjaCB0aG9zZSBi
aXRzIGFnYWluc3QgYSBuYW1lZCBmaWVsZCBhbmQgdGhpcyBsYXRlciBkb2VzIG5vdA0KPiBleGlz
dCBpbiB0YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaC5pbmMuDQo+IA0KPiBMZXQncyBzaWxlbmNlIHdh
cm5pbmdzIHVudGlsIHRob3NlIGJpdHMgZ2V0IGZpeGVkIGluIHRoZSBrZXJuZWwuDQo+IA0KPiBU
aGlzIHdhcyBvYnNlcnZlZCB3aXRoIHY3LjEtcmM0IGtlcm5lbC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gLS0tDQo+IHRhcmdldC9h
cm0va3ZtLmMgfCAyMyArKysrKysrKysrKysrKysrKysrLS0tLQ0KPiAxIGZpbGUgY2hhbmdlZCwg
MTkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90YXJn
ZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPiBpbmRleCA2MzczYTY2YmJkLi4xNjg4
Y2MyMTA2IDEwMDY0NA0KPiAtLS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+ICsrKyBiL3RhcmdldC9h
cm0va3ZtLmMNCj4gQEAgLTQwNSw2ICs0MDUsMTkgQEAgc3RhdGljIHZvaWQgZ2V0X3N5c3JlZ19w
cm9wKE9iamVjdCAqb2JqLCBWaXNpdG9yICp2LA0KPiAgICAgdHJhY2VfZ2V0X3N5c3JlZ19wcm9w
KG5hbWUsIHZhbHVlKTsNCj4gfQ0KPiANCj4gK3N0YXRpYyBib29sIGlnbm9yZV91bm5hbWVkX3dy
aXRhYmxlX2ZpZWxkKEFSTTY0U3lzUmVnICpyZWcsIGludCBpKQ0KPiArew0KPiArICAgIGlmICgo
IXN0cmNtcChyZWctPm5hbWUsICJJRF9JU0FSMF9FTDEiKSAmJiBpID49IDI4ICYmIGkgPD0gMzEp
IHx8IC8qIFJFUzAgKi8NCj4gKyAgICAgICAgKCFzdHJjbXAocmVnLT5uYW1lLCAiSURfSVNBUjVf
RUwxIikgJiYgaSA+PSAyMCAmJiBpIDw9IDIzKSB8fCAvKiBSRVMwICovDQo+ICsgICAgICAgICgh
c3RyY21wKHJlZy0+bmFtZSwgIk1WRlIyX0VMMSIpICYmIGkgPj0gOCAmJiBpIDw9IDMxKSB8fCAv
KiBSRVMwICovDQo+ICsgICAgICAgICghc3RyY21wKHJlZy0+bmFtZSwgIklEX1BGUjJfRUwxIikg
JiYgaSA+PSAxMiAmJiBpIDw9IDMxKSB8fCAvKiBSRVMwICovDQo+ICsgICAgICAgICghc3RyY21w
KHJlZy0+bmFtZSwgIklEX01NRlI1X0VMMSIpICYmIGkgPj0gOCAmJiBpIDw9IDMxKSB8fCAvKiBS
RVMwICovDQo+ICsgICAgICAgICghc3RyY21wKHJlZy0+bmFtZSwgIklEX0FBNjRGUEZSMF9FTDEi
KSAmJiBpID49IDIgJiYgaSA8PSA3KSkgeyAvKiBSQVogKi8NCj4gKyAgICAgICAgcmV0dXJuIHRy
dWU7DQo+ICsgICAgfQ0KPiArICAgIHJldHVybiBmYWxzZTsNCj4gK30NCj4gKw0KPiAvKg0KPiAg
KiBkZWNvZGVfaWRyZWdfd3JpdGVtYXA6IEdlbmVyYXRlIHByb3BzIGZvciB3cml0YWJsZSBmaWVs
ZHMNCj4gICoNCj4gQEAgLTQyNiwxMCArNDM5LDEyIEBAIGRlY29kZV9pZHJlZ193cml0ZW1hcChP
YmplY3QgKm9iaiwgaW50IGluZGV4LCB1aW50NjRfdCBtYXAsIEFSTTY0U3lzUmVnICpyZWcpDQo+
ICAgICAgICAgdWludDY0X3QgbWFzazsNCj4gDQo+ICAgICAgICAgaWYgKCFmaWVsZCkgew0KPiAt
ICAgICAgICAgICAgd2Fybl9yZXBvcnQoIiVzIGJpdCAlZCBvZiAlcyBpcyB3cml0YWJsZSBidXQg
bm8gbmFtZWQgZmllbGQgIg0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgImluIHRhcmdldC9h
cm0vY3B1LWlkcmVncy5oLmluYyIsDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICBfX2Z1bmNf
XywgaSwgcmVnLT5uYW1lKTsNCj4gLSAgICAgICAgICAgIHdhcm5fcmVwb3J0KCIlcyBpcyB0YXJn
ZXQvYXJtL2NwdS1pZHJlZ3MuaC5pbmM/IiwgX19mdW5jX18pOw0KPiArICAgICAgICAgICAgaWYg
KCFpZ25vcmVfdW5uYW1lZF93cml0YWJsZV9maWVsZChyZWcsIGkpKSB7DQo+ICsgICAgICAgICAg
ICAgICAgd2Fybl9yZXBvcnQoIiVzIGJpdCAlZCBvZiAlcyBpcyB3cml0YWJsZSBidXQgbm8gbmFt
ZWQgZmllbGQgIg0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICJpbiB0YXJnZXQvYXJt
L2NwdS1pZHJlZ3MuaC5pbmMiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fZnVu
Y19fLCBpLCByZWctPm5hbWUpOw0KPiArICAgICAgICAgICAgICAgIHdhcm5fcmVwb3J0KCIlcyBp
cyB0YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaC5pbmM/IiwgX19mdW5jX18pOw0KPiArICAgICAgICAg
ICAgfQ0KPiAgICAgICAgICAgICBtYXAgPSAgbWFwICYgfkJJVF9VTEwoaSk7DQo+ICAgICAgICAg
ICAgIGkgPSBjdHo2NChtYXApOw0KPiAgICAgICAgICAgICBjb250aW51ZTsNCj4g4oCUIA0KDQpU
aGlzIGlzIHdoeSBJIGZlZWwgdGhlIGdlbmVyYXRlZCBjcHUtaWRyZWdzLmguaW5jIHNob3VsZCBh
bHNvIGhhdmUgaW5mb3JtYXRpb24gb2YNClJFUzAvMSBmaWVsZHMgYXMgaW4gb3VyIFJGQy4gVGhl
c2UgZmllbGRzIHdpbGwgb2J2aW91c2x5IGhhdmUgb25seSBvbmUgYXJjaGl0ZWN0dXJhbGx5DQp2
YWxpZCB2YWx1ZSwgaGVuY2Ugd2Ugd2lsbCBuZXZlciBhbGxvdyB1c2VyIHRvIHdyaXRlIHNvbWV0
aGluZyBlbHNlLg0KDQpXYXJtIFJlZ2FyZHMsDQpLaHVzaGl0
