Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678C74CB8BD
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602960; cv=fail; b=eAHnvNlY71og7/LwFVfU8OPrJFBipjTtXQUOPgJz+9Ec9Hibv8xh7WSY3eELEpzBMLdhn6+ELJQvy/o7ITUXXdlL+iDV8gD2kgz3ARkFnAOmRRNDzXuy4/yzNuRv+0iiJax4FuxKP0smE/3eKxLQqEvIpqPP4LcmvSLa2NRNEqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602960; c=relaxed/simple;
	bh=3rgnhiZo/0WvpG2GpZIDNfcdpChW3SbBCszvasZniSs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IlLG4xRV9bokCDZ9vHFZK/KzczcFPULmRgYBacLDwiZ+fo4U3tw9KAbDt3Q60Mi7n7ktU9600pI5fcFfC+pRCSAuiXRfG4swT9Gk5EeXtZqB3IPDg1mQRJCH91vDIqZrsgHFKL71n5y5V8wgqAZsUoSgM1lu9iPYvSQI14oRZKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HlrQS0Q3; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ysSdaoIe; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HlrQS0Q3";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ysSdaoIe"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBCrVo1534943;
	Mon, 28 Sep 2026 06:42:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=3rgnhiZo/0WvpG2GpZIDNfcdpChW3SbBCszvasZni
	Ss=; b=HlrQS0Q3bhWnLWY6EZES2PPkMmFqfXxz4FjVEUQAipmht9s7ZhsZHK73z
	eiogVpZwW454Q5LoDM88Q0QuwfNeirn+joDKTN+tqXP+HeNN29pSKYXAu7+Lius0
	i92Vtrxnus08HyCv54+8my6LhfcUdpjEZIkQvKI7olfI9Z7F5o/dv/g5sbyLwQd3
	PTAH+glwghmFAzvvUfZBTv94C2b76bvN7r2ucQOVpwDzZYW1Ycac2a9Hkolrr9RM
	mkRdgtBvPfH1zrzvIETDXCQQ2pkAADV0Hn19VzP9q61BKp7WGnrtQSAkLXaMZysH
	5L4MqcRvdVASu2vK+USqZWToVMU2w==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022110.outbound.protection.outlook.com [40.107.200.110])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gx9y744u5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 06:42:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tydf4qK9J3s+hDJr2hlov1HlvEjlLswCGDWjZuQxKyisENcsy2aEvhQvCL5jQ4hYndlFsw3ZCy6k5l/YvTf65FMcjvTklG90yR3gBWPbizK/ZZ+jIeAYI7aY5xuNaEimMu85xFnpovhkk63XCyALa2AT+0batcvDYPeAfy+TEk62BFYMnKoAxZOkvHz/nAe0N8SAyFTR+zwL66qkupKnBRprF3jz5CwKQMjBo0sbsOI+RQjwhoSMlGYtBZtaQWV1YijyjW6QpTV57DY2JuerVT42UbgyIZTt/BoJ5IegRBAEIkz3j5b3LEe6fCZFz+GLRs8Gpyi5HrDkri3XSind6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rgnhiZo/0WvpG2GpZIDNfcdpChW3SbBCszvasZniSs=;
 b=t8lLOPE2KriOE7jUF0fAitirn6usC3b0mSGvEjSiar2M7/mdzkain0iqex1W1YJo5Dv5B3nTMHX3MXda5/9lL9zx46RW1nx1ueTBtI0zpxF0jr7mYsr1IFpHhzX9Vsqxv/PnagmeMqqWW7t8alsTE3i+bFJXgqdUzHCzSKiO9ZZzH7zOE5aJ1K/RIEXhlkT41fYR7AG5C/Udfi4RBHU86n9oBvEPMHM6/BbggC9BEm/qN03z5z5hLQNX2q8MRTF8Jxt0Rdo5Z7vRxQPEJFZ8RxTCFZLLFQNQb3tK6ZH+74Ajzkv4+I8t4J3I5XiV/9Y4nshKwTxpCqNk2SNgYQya2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rgnhiZo/0WvpG2GpZIDNfcdpChW3SbBCszvasZniSs=;
 b=ysSdaoIemut1ZKcRyHlpTORFVP8Gl2RSIXF0WDFHUDiczkhVEnmWa+/Jd8EW7/PnnDVKHxaSNT4A9GUna+SJnkRiJUtZJjDQKRTFKIQGc5KmGlQOpxZkePQIlYbwVWF0JgqSMczUgIjYHamwOCrBPXLiJNvR9//1u0O64icskzyHQqMNvnjbf2OoWUd4qfWyka9nOBbzHx48Dma78ug+3g8Xj37EEZNNyOos8y/dvHkDGMYtyYaLI40SS3zQtXZm6oRqudQfoAnJHeMOZM/D15+HV+KI9LyYmSwxivmXNqDe0JjwvJj2BCqEeQ6mSdcUB6+LaE7Q/MnzJJIF3ecK/w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by MW6PR02MB9815.namprd02.prod.outlook.com (2603:10b6:303:23c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 13:42:14 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 13:42:14 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
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
Thread-Index: AQHdTyvA9mcebWLrrkq/kOH2eEpLs7bj4G6AgAAZhQCAAANQgIAAAq+A
Date: Mon, 28 Sep 2026 13:42:13 +0000
Message-ID: <3E89CD44-4EFE-43BF-ADA4-9DD6E43FF3F1@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-15-eric.auger@redhat.com>
 <ABBAB5A1-BD41-4D5C-9D09-DD1D7C50D0FB@nutanix.com>
 <810074ff-60af-4b36-9a7b-9b5ce4117eb4@redhat.com>
 <8FDF1B75-E523-4FFD-81A7-710D5EDDCA1D@nutanix.com>
 <f256d217-d83c-48a4-8724-24ac56878ca4@redhat.com>
In-Reply-To: <f256d217-d83c-48a4-8724-24ac56878ca4@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|MW6PR02MB9815:EE_
x-ms-office365-filtering-correlation-id: 8e911ec4-1199-4446-f8f6-08df1d664dd6
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|38070700021|56012099006|3023799007|10067099003|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 c1rxgwp2LufSQizLqI5qYnq8cO/Ut488nxrJ0l+FtFuNLaEWd6UihJk+yUcNLT13AD3t7TCK6kxELd5Wzf5K8Dtgz3gluly/saBDKy7c3QWgFw4CNmWyEu6no6KvbYkClpHi4t1oP1LK8GmKPLiNGXUTxMiDgFBKw3C1u45Q+Vw/sirc6AEGNNC+NEuBgBQ/QwVPVooo2HIvCA+Ibp5gYv4GtycLzMhOMJMg+F52b0mnLaPQKIUbx3aSf66by+CSxLowDU+RsPRyCLHukbfmBkPF+q6UoI/fGcd3r7fh5TtA5AFl/wmUUuoNsMSHrAkq7YqyLTF221xhKaqZBgluF6j1qGNJPBHrk7sp+1nijk1chzKNC4l2YIx2aViLj6jmq/Z+BKAH0spISH5R0+gw5V/BgyDsU3H09xy/4YfcLSoUy7pyoSIPYoiasta7ND29HlO+PCuhsUPVCBH1G2+psWfiZOQmKPNtyfxTCtdx7eIoJi9xFd9JlsVgGivAtX/d06B/onFNAwOXSS7S+0GSiFfUFRugrDEFOUTHNmCeFEVhBm+Vh5qdf1GdIFs1vAG9ZqpYw4fjOaxR0/HevBAqCJg3aAoxCeWTCR6QEhYE04Yqzq7a4GvgQOk0ZOx/oxMkLydhSGqZE+d5laiGWJUTH5b49GKCWudEiepHfKLEJzYCKycoTPwxMgTsdsDY5/rf8zrn9XE/EJNrnU7daEg57A6Gm74jyYukVC7COCZnnBs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(38070700021)(56012099006)(3023799007)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ODhZRlJFZ3RwbU9ZSDNjV2xQMzQ1VTNMUlBDNW9ZSndYaTh0OUNMUkQ5NWFN?=
 =?utf-8?B?WGhqb1ZTZC82bjFlQXBmSWJhNndybFJYS0lIYUJFS2o1cEtpOGVBRVAwVS9Z?=
 =?utf-8?B?cWwvaytpQnZhYzd4M2k2blA3YVZEdEhCMEVqeXNtaW13YndCTDNJdjhVSkZy?=
 =?utf-8?B?VE44RDZ5ckdPcmxyWVUySmRwYXRqQ1hwcXJrQnUyVGRCdll5a04vQUZITUM4?=
 =?utf-8?B?S1BKcFpDRnEvY0ZJTVBFTzN0aFhlaFYvTFF2b3JFMkQzcVNTNGlnelRERGxQ?=
 =?utf-8?B?czgybVhneHZjT2xUTisxR29yKzVRWlkrbzBRL0lIeGpGeUpabmlZTmlydnM1?=
 =?utf-8?B?RkFDT250dUVqK2RTMlg5cEhXV0N1bXJpS0JzS3d1TDhMVjU4cWpwOHZ4R3F3?=
 =?utf-8?B?UldtYzZMZjlHUmg1MEVMeXdwTHRNWVE4bEZPQUVzdXhhNVZpZ1J3MkVOcmts?=
 =?utf-8?B?SUpRTHE0cWo1alUrOTROY3hRTUhzeWNhcmJmMm5wNDQ4cFcrSG9QV2hQQXA3?=
 =?utf-8?B?MWJTamdlSG5GSVhVWmpNSVNZREdyc203RVFWSWxvZ0wzdElydTR0d0VYQWV0?=
 =?utf-8?B?UHBURUhNM0hLUTIzdjlQdGhtbVgxNjVUZWdaS3hTZm1qQ2N2VTZoMjl1Undq?=
 =?utf-8?B?VHp6UDR1azlRWk1SK0ozUGM2UEZXNndiZzhxYVVLbC9sRUJrdFZRMlY1VG5n?=
 =?utf-8?B?UFBEcjA3OXFmMkxlUnR2Y0Rjd3FKS2txdTAwM0dZNkpJQXpFWU8zN0xWTEFB?=
 =?utf-8?B?YU5tZUVjTThuRi9lNDRJbVo0K2JPcXJDbVkwNXhaNk1wRkgwNFV6SGx3ZXJo?=
 =?utf-8?B?eE5ZVXZGd2ZtcC8rdno5bXdtaVNFdVhOc3hPWEhMdCtxT2k4SEVHV0ZaWnJi?=
 =?utf-8?B?ZEZXWUFBQm5hMElNMVpMOGdUN3U1MXZkUzhXY3U1d1BhTUd3b1hJMkZLYUtj?=
 =?utf-8?B?YjJaWTVTeFBITU1FWVI2Q2x6VFF1N1BQSWxibmRoQjE1cjBiay9KSUErY21i?=
 =?utf-8?B?ZUpoMm5mQjl0b2xkRjAyT1ZWMHVkcDh4YnNkaWgzcFI1b1RLbVVWeG94alpj?=
 =?utf-8?B?UVN4anNYTjFyZG0zcUpqYU9DRlVVTmJSaGlTNE9McUpRbmZpQzdjQUNjVDQ4?=
 =?utf-8?B?SGFWOWpQUjV2RVZtRWhlN3FPNXF1Y0l4ajhuWjRlWkk0T1hydTU3NEIzMjZN?=
 =?utf-8?B?NjNITE80bGJRTVBoUmRJSGdrT3h4eVpmQU1QZ2IxeXhNOFFIZ1FaNXRpNVVP?=
 =?utf-8?B?NElnRWVXck85MXpJQXBBWUFhTGJmRGs1WnlDRUFwNTFscTRJTEhNVjhMa3pq?=
 =?utf-8?B?a2FFcXR3M0Zwd2k2bkdBYnRtdS9HWmdOMHRkMzhmZVo1YUxaL3l3T2dGUzBW?=
 =?utf-8?B?ZUF0TldQa2xuVDJuOXZUZGlBbDZUMWJVOElxL3VCNkRzeWs5c0NiZVB0aDc5?=
 =?utf-8?B?M2dheFRvVkVNNlpwWkRaWEVJc0N5MXBDY0wxQ25iZTF3Vks4ZUxMT3RoYm1s?=
 =?utf-8?B?SmZxWlZNTlRQYytjaGpuUjZqakRGWVJ6UHY4aXlRbVpJUE5lOU02U2ZQRU8w?=
 =?utf-8?B?WHJZdVpjNUVVd3JpS3R3YzN4MVRUU0FKM3JkVXBTcVZMMTJwRkd2S2hRTmI5?=
 =?utf-8?B?RDhudHVCV0pIZUlHQXYwWk5ReUNtNndzVUpqeURsUDRrSnczME12dXpDcEp4?=
 =?utf-8?B?RkdWUXZLdm5ySEt5a00zUjZsTUVyZWZWeEllRFNIbGhxY1p2QzBwMlJFdmEw?=
 =?utf-8?B?UElUMUhlV3dKeGtIZUczRWJYSmhkYmk2UE8vdW0vRDMxNUx5Mzk5RVNNdjJO?=
 =?utf-8?B?Tzc1NjZuUGg5Q2syV2ZkbEg0dVpXRVNMaGpBK0F2WjJxaS9LKzB4STVaK09r?=
 =?utf-8?B?T3k3czRmT1Z0K2dISnkzM2pRdHppVm5tRWlFd2svcnZGTVQvdXhmU3RCOXBP?=
 =?utf-8?B?TFkvb2xDRHdBWjUrQ3dmdzB1em8zMVJCSDc0YjBhdkIxdk9iZFcwQXd0T1Ir?=
 =?utf-8?B?OGxqQUp3WjMzbDhpcUtWVmJSWHBYK1NLMnJBdHBWVjhjS1RjQWFuODhYQ0d5?=
 =?utf-8?B?cE01eUVUNm4wYmFuTTBJVnoxYWpLa0JlTCtBdlZZMTRKK21GdEpzUzF2NVhW?=
 =?utf-8?B?K0pCRCtneDN3d3R4M2l2dnluNjlvMmMvN3gvWW0yZXZ0WC9TUVp2MHE2TWZm?=
 =?utf-8?B?a2ZtajFqOUtZdFlJREFIelpsUEF5cy9yNXltNVNldFk5c0Rtc0d3dkRJL0l4?=
 =?utf-8?B?R0VteWN3cndwU3k5Rjc1c1lxTWUvcjdVUGxHa0V4N2I4cC9aNkFnNUtGenE1?=
 =?utf-8?B?MUpPbjgzNGRzMEtnMEhxa09JVUVkZnpxRVcwQWVJSk5tNlp4UTZIakYvYUww?=
 =?utf-8?Q?DYIy9a8rnIo4Z4uE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F580E1FE09169F459C57A974480EB6CF@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	GMXhHlHQLzbGmLriDMrkz8//v5wLe63BEfuEIiOLZw62pMFI+0tWvHNckOahJ2Enuu9TQakuh2o4aSSF3okMidH/gtzqJMruZZhqQj/tIinkMY/RftY9PxO98zP2oelNUSQfywB9NPz2pU/sMRtd75JyLN8mmXRJL6jIU/+UzeU5xD+FXLOkdIUBCfhww1vXY5NTKaZHr/yZ0u4zbeD695s2Bg4HtWwUlLNF0YdPeYi3Xzwirjm0xO+Th1o7rlbFzH+IPlUn2/4yIFi83PzMYzQdyNfkr5uVZdGJmLNLk4GoxsJ7Tr8C/o3Xx9A8fapu+q96Sp+uOQGYvnycfHsX8A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e911ec4-1199-4446-f8f6-08df1d664dd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 13:42:13.9080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UNt+LgJQgeQfW89zLmpi+2QNYZYpPz+po4NjlL0MXC/chGzRoBJ50NgtupOsRwUwDIp7PiMe6uOO5n8AqOsneS3w9VHJRVmmgS+q1pANyaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR02MB9815
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA1NCBTYWx0ZWRfXzvHyc6mfOtKC
 h+770SAemgegKYcoFHgpzV5k444ODejHUuNVGzZXQPAjObPkO8yGu0bSvkMKqrB0hO9Fqhyxx2u
 dueQ7BqTyJoa+IwOlBVfZbFw+8e8GFA1EjvnQxRLFwUShMhQGLk/xFqPrOofVuFbcBtOsDn3I9e
 VVKsOlr5nwgGLqXBTpReaOzuf6N3tFY9ogKONYsohWthIRBK51y4blzBtmVKEnQa6ixm8eqPIDU
 s/uoWHo72mAwoncImZTiAOc3U/V36KJlqMTOS5yhfpkfngvT0s7WUsZKi+ei1T1/nQPMzCCfUku
 Kvrcco/U+NWXmr6gYkHrvGvSXV5ycncZq7/X2zP5sVwPCkkyFs1ma9SEdjwCvzBGyKmbiYt5EhN
 5WzLiO1PjkTzj3STSIRl4ABbCJNtxSXB9dlD7fDGHSsBXbC6zWT3miOkvDvDMFIV2ztHGbe3C4W
 wVw+n7rPLUaeAFY6NmQ==
X-Proofpoint-ORIG-GUID: 9SgiZ3ZJ-OzbW4h4CfEODEMvELc2S-dW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA1NCBTYWx0ZWRfX1RNSbBPX+3zB
 s6/EFyfkH3sU8KDujairJ0nwoKK9C5Jy8iUem09xfFfsyIjE1LPrm+hSXfTANRVjOvE1oUMWuJc
 /Gl6NX20dfhmhdgkruLUuA3GAJwc3ek=
X-Authority-Analysis: v=2.4 cv=c/A+0h9l c=1 sm=1 tr=0 ts=6aba6ebc cx=c_pps
 a=ZQ5czZ6yTY4ZD+V8z0ndCg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=64Cc0HZtAAAA:8
 a=20KFwNOVAAAA:8 a=k9yIF0htcBlVOeXH8gMA:9 a=lqcHg5cX4UMA:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 9SgiZ3ZJ-OzbW4h4CfEODEMvELc2S-dW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjggU2VwIDIwMjYsIGF0IDc6MDLigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gDQo+IA0KPiBPbiA5LzI4LzI2
IDM6MjAgUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IA0KPj4+IE9uIDI4IFNlcCAyMDI2LCBh
dCA1OjE54oCvUE0sIEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+
Pj4gDQo+Pj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+Pj4gQ0FVVElPTjogRXh0ZXJuYWwgRW1haWwNCj4+PiAN
Cj4+PiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLSENCj4+PiANCj4+PiBIaSBLaHVzaGl0LA0KPj4+IA0KPj4+IE9uIDkv
MjgvMjYgMTE6MjggQU0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+Pj4+IE9uIDE2IFNlcCAyMDI2
LCBhdCA4OjE14oCvUE0sIEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4gd3JvdGU6
DQo+Pj4+PiANCj4+Pj4+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPj4+Pj4gQ0FVVElPTjogRXh0ZXJuYWwgRW1h
aWwNCj4+Pj4+IA0KPj4+Pj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+Pj4+PiANCj4+Pj4+IFdoZW4gdGhlIHNl
dHRlciBpcyBjYWxsZWQsIHRoZSBmaW5hbCB2Y3B1IGlzIG5vdCBjcmVhdGVkIHlldC4NCj4+Pj4+
IEFwcGx5aW5nIHRoZSBvdmVycmlkZSBvbiB2Y3B1LmlzYXIgaW5pdGlhbGl6ZWQgd2l0aCB0aGUg
bWF4IHNjcmF0Y2gNCj4+Pj4+IHZjcHUgd291bGQgbm90IGJlIGNvcnJlY3QgYmVjYXVzZSB0aGUg
ZmluYWwgdmNwdSBtYXkgaGF2ZSBzb21lIGZlYXR1cmVzDQo+Pj4+PiB0dXJuZWQgb2ZmIChmb3Ig
aW5zdGFuY2UgdmlydHVhbGl6YXRpb24pIHdoaWxlIHRoZSBzY3JhdGNoIHZjcHUNCj4+Pj4+IGZl
YXR1cmVzIGl0LiBTbyB3ZSBuZWVkIHRvIHBvc3Rwb25lIHRoZSBhY3R1YWwgb3ZlcnJpZGUgdW50
aWwgdGhlDQo+Pj4+PiBmaW5hbCB2Y3B1IGhhcyBiZWVuIGluaXRpYWxpemVkLg0KPj4+Pj4gDQo+
Pj4+PiBJbiB0ZXJtcyBvZiBpbnB1dCB2YWx1ZSB2YWxpZGF0aW9uIHdoYXQgY2FuIGJlIGRvbmUg
bm93IGlzIGNoZWNraW5nDQo+Pj4+PiBhZ2FpbnN0IGZpZWxkIGxlbmd0aCBhbmQgYXJjaCBlbnVt
IHZhbHVlIGlmIGFueS4NCj4+Pj4+IA0KPj4+Pj4gSWYgdGhpcyBzdWNjZWVkcywgdGhlIGZpZWxk
IHZhbHVlIGlzIGFkZGVkIGluIHRoZSBoYXNoIHRhYmxlIHRvIGJlDQo+Pj4+PiB3cml0dGVuIGxh
dGVyIG9uIG9uY2UgdGhlIGZpbmFsIHZjcHUgaGFzIGJlZW4gY3JlYXRlZA0KPj4+Pj4gDQo+Pj4+
PiBXaXRoIHJlZ2FyZHMgdG8gdGhlIGdldHRlciwgaWYgdGhlIHN5c3JlZyBwcm9wIHdhcyBzZXQs
IHdlIHJldHVybiB0aGUNCj4+Pj4+IHNldCB2YWx1ZSwgb3RoZXJ3aXNlLCB3ZSByZXR1cm4gdGhl
IHZhbHVlIGluIGNwdS0+aXNhci5pZHJlZ3NbXS4NCj4+Pj4+IA0KPj4+PiBIaSBFcmljLA0KPj4+
PiANCj4+Pj4gUGxlYXNlIG1lbnRpb24gdGhhdCB0aGUgY3ByZWcgb3ZlcnJpZGUgaGFwcGVucyBp
biBsYXRlciBjb21taXRzLg0KPj4+IHN1cmUNCj4+Pj4gU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBT
aGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20gPG1haWx0bzpraHVzaGl0LnNoYWhAbnV0YW5p
eC5jb20+Pg0KPj4+IE1heSBJIGFzayB3aHk/DQo+Pj4gDQo+Pj4gQmVzaWRlcyB3ZSBuZWVkIHRv
IGJlIGNhdXRpb3VzIGFib3V0IHRoZSBmYWN0IHRoYXQgcGVvcGxlIHdobyBoYXMgc2lnbmVkDQo+
Pj4gb2ZmIHRoZSBwYXRjaGVzIGNhbm5vdCByZXZpZXcgdGhlbSAuLi4NCj4+IE9oaCBzb3JyeSwg
SSBtZWFudA0KPj4gDQo+PiBSZXZpZXdlZC1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhA
bnV0YW5peC5jb20gPG1haWx0bzpraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+Pg0KPiANCj4gYWgg
b2sgdGhhbmtzLiANCj4gQnkgdGhlIHdheSBkbyB5b3UgbWVhbjoNCj4gUmV2aWV3ZWQtYnk6IEto
dXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KWWVzLCB0aGlzIGxvb2tzIGNv
cnJlY3QgOikNCg0KPiBJIGRvbid0IGtub3cgaWYgeW91cnMgaXMgYSBjb3JyZWN0IFItYiBmb3Jt
IGJ1dCBtYXliZT8NCj4gDQo+IEVyaWMNCj4gDQo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+Pj4+PiAtLS0NCj4+Pj4+IHRhcmdldC9hcm0v
Y3B1LmggfCAgMiArKw0KPj4+Pj4gdGFyZ2V0L2FybS9jcHUuYyB8ICA1ICsrLS0NCj4+Pj4+IHRh
cmdldC9hcm0va3ZtLmMgfCA2NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrLS0NCj4+Pj4+IDMgZmlsZXMgY2hhbmdlZCwgNjggaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkNCj4+Pj4+IA0KPj4+Pj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0vY3B1Lmgg
Yi90YXJnZXQvYXJtL2NwdS5oDQo+Pj4+PiBpbmRleCBlM2Y5MzFkYmEyLi45YmJkNDJkZDJiIDEw
MDY0NA0KPj4+Pj4gLS0tIGEvdGFyZ2V0L2FybS9jcHUuaA0KPj4+Pj4gKysrIGIvdGFyZ2V0L2Fy
bS9jcHUuaA0KPj4+Pj4gQEAgLTk1Miw2ICs5NTIsOCBAQCBzdHJ1Y3QgQXJjaENQVSB7DQo+Pj4+
PiAgIHVpbnQ2NF90ICpjcHJlZ192bXN0YXRlX3ZhbHVlczsNCj4+Pj4+ICAgaW50MzJfdCBjcHJl
Z192bXN0YXRlX2FycmF5X2xlbjsNCj4+Pj4+IA0KPj4+Pj4gKyAgICBHSGFzaFRhYmxlICpzeXNy
ZWdfcHJvcHM7DQo+Pj4+PiArDQo+Pj4+PiAgIER5bmFtaWNHREJGZWF0dXJlSW5mbyBkeW5fc3lz
cmVnX2ZlYXR1cmU7DQo+Pj4+PiAgIER5bmFtaWNHREJGZWF0dXJlSW5mbyBkeW5fc3ZlcmVnX2Zl
YXR1cmU7DQo+Pj4+PiAgIER5bmFtaWNHREJGZWF0dXJlSW5mbyBkeW5fc21lcmVnX2ZlYXR1cmU7
DQo+Pj4+PiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9jcHUuYyBiL3RhcmdldC9hcm0vY3B1LmMN
Cj4+Pj4+IGluZGV4IDc3YWE3OGYwMGUuLjkxN2Y3MDljYjQgMTAwNjQ0DQo+Pj4+PiAtLS0gYS90
YXJnZXQvYXJtL2NwdS5jDQo+Pj4+PiArKysgYi90YXJnZXQvYXJtL2NwdS5jDQo+Pj4+PiBAQCAt
MTIzNiw4ICsxMjM2LDggQEAgc3RhdGljIHZvaWQgYXJtX2NwdV9pbml0Zm4oT2JqZWN0ICpvYmop
DQo+Pj4+PiB7DQo+Pj4+PiAgIEFSTUNQVSAqY3B1ID0gQVJNX0NQVShvYmopOw0KPj4+Pj4gDQo+
Pj4+PiAtICAgIGNwdS0+Y3BfcmVncyA9IGdfaGFzaF90YWJsZV9uZXdfZnVsbChnX2RpcmVjdF9o
YXNoLCBnX2RpcmVjdF9lcXVhbCwNCj4+Pj4+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIE5VTEwsIGdfZnJlZSk7DQo+Pj4+PiArICAgIGNwdS0+Y3BfcmVncyA9IGdf
aGFzaF90YWJsZV9uZXcoZ19kaXJlY3RfaGFzaCwgZ19kaXJlY3RfZXF1YWwpOw0KPj4+Pj4gKyAg
ICBjcHUtPnN5c3JlZ19wcm9wcyA9IGdfaGFzaF90YWJsZV9uZXcoZ19kaXJlY3RfaGFzaCwgZ19k
aXJlY3RfZXF1YWwpOw0KPj4+Pj4gDQo+Pj4+PiAgIFFMSVNUX0lOSVQoJmNwdS0+cHJlX2VsX2No
YW5nZV9ob29rcyk7DQo+Pj4+PiAgIFFMSVNUX0lOSVQoJmNwdS0+ZWxfY2hhbmdlX2hvb2tzKTsN
Cj4+Pj4+IEBAIC0xNzI1LDYgKzE3MjUsNyBAQCBzdGF0aWMgdm9pZCBhcm1fY3B1X2ZpbmFsaXpl
Zm4oT2JqZWN0ICpvYmopDQo+Pj4+PiAgIEFSTUNQUmVnTWlnVG9sZXJhbmNlICp0LCAqbjsNCj4+
Pj4+IA0KPj4+Pj4gICBnX2hhc2hfdGFibGVfZGVzdHJveShjcHUtPmNwX3JlZ3MpOw0KPj4+Pj4g
KyAgICBnX2hhc2hfdGFibGVfZGVzdHJveShjcHUtPnN5c3JlZ19wcm9wcyk7DQo+Pj4+PiANCj4+
Pj4+ICAgUUxJU1RfRk9SRUFDSF9TQUZFKGhvb2ssICZjcHUtPnByZV9lbF9jaGFuZ2VfaG9va3Ms
IG5vZGUsIG5leHQpIHsNCj4+Pj4+ICAgICAgIFFMSVNUX1JFTU9WRShob29rLCBub2RlKTsNCj4+
Pj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4+
Pj4gaW5kZXggMzQxNTQyMjc5ZC4uY2RjMzc3OTMyMSAxMDA2NDQNCj4+Pj4+IC0tLSBhL3Rhcmdl
dC9hcm0va3ZtLmMNCj4+Pj4+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4+Pj4+IEBAIC0zNDAs
MTggKzM0MCw3OSBAQCBzdGF0aWMgQVJNNjRTeXNSZWdGaWVsZCAqZ2V0X2ZpZWxkKGludCBpLCBB
Uk02NFN5c1JlZyAqcmVnKQ0KPj4+Pj4gICByZXR1cm4gTlVMTDsNCj4+Pj4+IH0NCj4+Pj4+IA0K
Pj4+Pj4gKyNkZWZpbmUgTUFLRV9JRFJFR19LRVkocmVnX2lkeCwgZmllbGRfc2hpZnQpIFwNCj4+
Pj4+ICsgICAgKCgodWludDY0X3QpKHJlZ19pZHgpIDw8IDgpIHwgKCh1aW50NjRfdCkoZmllbGRf
c2hpZnQpICYgMHhGRikpDQo+Pj4+PiArDQo+Pj4+IE1heWJlLCBJRFJFR19GSUVMRF9LRVkoKT8N
Cj4+PiBZZXMNCj4+PiANCj4+PiBFcmljDQo+Pj4+IFdhcm0gUmVnYXJkcywNCj4+Pj4gS2h1c2hp
dA0KPj4+Pj4gc3RhdGljIHZvaWQgc2V0X3N5c3JlZ19wcm9wKE9iamVjdCAqb2JqLCBWaXNpdG9y
ICp2LA0KPj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICpuYW1lLCB2
b2lkICpvcGFxdWUsDQo+Pj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgIEVycm9yICoqZXJy
cCkNCj4+Pj4+IHsNCj4+Pj4+IC0gICAgZXJyb3Jfc2V0ZyhlcnJwLCAiJXMgc2V0dGVyIG5vdCB5
ZXQgaW1wbGVtZW50ZWQiLCBuYW1lKTsNCj4+Pj4+ICsgICAgQVJNNjRTeXNSZWdGaWVsZCAqZmll
bGQgPSAoQVJNNjRTeXNSZWdGaWVsZCAqKW9wYXF1ZTsNCj4+Pj4+ICsgICAgQVJNQ1BVICpjcHUg
PSBBUk1fQ1BVKG9iaik7DQo+Pj4+PiArICAgIGludCBpbmRleCA9IGZpZWxkLT5pbmRleDsNCj4+
Pj4+ICsgICAgaW50IGxvd2VyID0gZmllbGQtPnNoaWZ0Ow0KPj4+Pj4gKyAgICBpbnQgbGVuZ3Ro
ID0gZmllbGQtPmxlbmd0aDsNCj4+Pj4+ICsgICAgdWludDY0X3Qga2V5LCB2YWx1ZTsNCj4+Pj4+
ICsNCj4+Pj4+ICsgICAgaWYgKCF2aXNpdF90eXBlX3VpbnQ2NCh2LCBuYW1lLCAmdmFsdWUsIGVy
cnApKSB7DQo+Pj4+PiArICAgICAgICByZXR1cm47DQo+Pj4+PiArICAgIH0NCj4+Pj4+ICsNCj4+
Pj4+ICsgICAgaWYgKGxlbmd0aCA8IDY0ICYmIHZhbHVlID4gKCgxIDw8IGxlbmd0aCkgLSAxKSkg
ew0KPj4+Pj4gKyAgICAgICAgZXJyb3Jfc2V0ZyhlcnJwLA0KPj4+Pj4gKyAgICAgICAgICAgICAg
ICAgICAiaWRyZWcgJXMgc2V0IHZhbHVlICgweCVseCkgZXhjZWVkcyBsZW5ndGggb2YgZmllbGQg
KCVkKSEiLA0KPj4+Pj4gKyAgICAgICAgICAgICAgICAgICBuYW1lLCB2YWx1ZSwgbGVuZ3RoKTsN
Cj4+Pj4+ICsgICAgICAgIHJldHVybjsNCj4+Pj4+ICsgICAgfQ0KPj4+Pj4gKw0KPj4+Pj4gKyAg
ICBpZiAoZmllbGQtPmFyY2hfdmFscykgew0KPj4+Pj4gKyAgICAgICAgLyogdGhpcyBmaWVsZCBo
YXMgc29tZSBlbnVtIHZhbHVlcyAqLw0KPj4+Pj4gKyAgICAgICAgZm9yIChpbnQgaSA9IDA7IGkg
PCBmaWVsZC0+YXJjaF92YWxzX2NvdW50OyBpKyspIHsNCj4+Pj4+ICsgICAgICAgICAgICBpZiAo
dmFsdWUgPT0gZmllbGQtPmFyY2hfdmFsc1tpXSkgew0KPj4+Pj4gKyAgICAgICAgICAgICAgICBn
b3RvIHZhbGlkOw0KPj4+Pj4gKyAgICAgICAgICAgIH0NCj4+Pj4+ICsgICAgICAgIH0NCj4+Pj4+
ICsgICAgICAgIGVycm9yX3NldGcoZXJycCwNCj4+Pj4+ICsgICAgICAgICAgICAgICAgICAgImlk
cmVnICVzIHNldCB2YWx1ZSAoMHglbHgpIGRvZXMgbm90IG1hdGNoIGFueSAiDQo+Pj4+PiArICAg
ICAgICAgICAgICAgICAgICJhcmNoIHZhbGlkIGVudW0gdmFsdWUiLCBuYW1lLCB2YWx1ZSk7DQo+
Pj4+PiArICAgICAgICByZXR1cm47DQo+Pj4+PiArICAgIH0NCj4+Pj4+ICsNCj4+Pj4+ICt2YWxp
ZDoNCj4+Pj4+ICsNCj4+Pj4+ICsgICAga2V5ID0gTUFLRV9JRFJFR19LRVkoaW5kZXgsIGxvd2Vy
KTsNCj4+Pj4+ICsgICAgZ19oYXNoX3RhYmxlX2luc2VydChjcHUtPnN5c3JlZ19wcm9wcywgR1VJ
TlRfVE9fUE9JTlRFUihrZXkpLA0KPj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgR1VJTlRf
VE9fUE9JTlRFUih2YWx1ZSkpOw0KPj4+Pj4gfQ0KPj4+Pj4gDQo+Pj4+PiBzdGF0aWMgdm9pZCBn
ZXRfc3lzcmVnX3Byb3AoT2JqZWN0ICpvYmosIFZpc2l0b3IgKnYsDQo+Pj4+PiAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKm5hbWUsIHZvaWQgKm9wYXF1ZSwNCj4+Pj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgRXJyb3IgKiplcnJwKQ0KPj4+Pj4gew0KPj4+Pj4gLSAg
ICBlcnJvcl9zZXRnKGVycnAsICIlcyBnZXR0ZXIgbm90IHlldCBpbXBsZW1lbnRlZCIsIG5hbWUp
Ow0KPj4+Pj4gKyAgICBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCA9IChBUk02NFN5c1JlZ0ZpZWxk
ICopb3BhcXVlOw0KPj4+Pj4gKyAgICBBUk1DUFUgKmNwdSA9IEFSTV9DUFUob2JqKTsNCj4+Pj4+
ICsgICAgaW50IGluZGV4ID0gZmllbGQtPmluZGV4Ow0KPj4+Pj4gKyAgICBpbnQgbG93ZXIgPSBm
aWVsZC0+c2hpZnQ7DQo+Pj4+PiArICAgIGludCBsZW5ndGggPSBmaWVsZC0+bGVuZ3RoOw0KPj4+
Pj4gKyAgICBncG9pbnRlciB2YWx1ZV9wdHI7DQo+Pj4+PiArICAgIHVpbnQ2NF90IHZhbHVlOw0K
Pj4+Pj4gKyAgICB1aW50NjRfdCBrZXkgPSBNQUtFX0lEUkVHX0tFWShpbmRleCwgbG93ZXIpOw0K
Pj4+Pj4gKyAgICBnYm9vbGVhbiBleGlzdHM7DQo+Pj4+PiArDQo+Pj4+PiArICAgIGV4aXN0cyA9
IGdfaGFzaF90YWJsZV9sb29rdXBfZXh0ZW5kZWQoY3B1LT5zeXNyZWdfcHJvcHMsDQo+Pj4+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgR1VJTlRfVE9fUE9JTlRF
UihrZXkpLCBOVUxMLA0KPj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICZ2YWx1ZV9wdHIpOw0KPj4+Pj4gKyAgICBpZiAoZXhpc3RzKSB7DQo+Pj4+PiArICAg
ICAgICB2YWx1ZSA9IEdQT0lOVEVSX1RPX1VJTlQodmFsdWVfcHRyKTsNCj4+Pj4+ICsgICAgfSBl
bHNlIHsNCj4+Pj4+ICsgICAgICAgIHVpbnQ2NF90IG1hc2sgPSBNQUtFXzY0QklUX01BU0sobG93
ZXIsIGxlbmd0aCk7DQo+Pj4+PiArICAgICAgICB1aW50NjRfdCAqaWRyZWdzID0gY3B1LT5pc2Fy
LmlkcmVnczsNCj4+Pj4+ICsNCj4+Pj4+ICsgICAgICAgIHZhbHVlID0gKGlkcmVnc1tpbmRleF0g
JiBtYXNrKSA+PiBsb3dlcjsNCj4+Pj4+ICsgICAgfQ0KPj4+Pj4gKw0KPj4+Pj4gKyAgICB2aXNp
dF90eXBlX3VpbnQ2NCh2LCBuYW1lLCAmdmFsdWUsIGVycnApOw0KPj4+Pj4gKyAgICB0cmFjZV9n
ZXRfc3lzcmVnX3Byb3AobmFtZSwgdmFsdWUpOw0KPj4+Pj4gfQ0KPj4+Pj4gDQo+Pj4+PiAvKg0K
Pj4+Pj4gLS0gDQo+Pj4+PiAyLjUzLjANCg0KDQo=
