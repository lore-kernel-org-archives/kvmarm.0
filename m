Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3C5343888
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 05:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779944888; cv=fail; b=Dg0KROeuAYln5xC34PhPysdQpE9XUDAvnrJ7QWiqtU8dbpKDk6nYxhCxMl5jlIfi4b25xWsOT1IFlWjaHqygPv2kBLnJUfz+12W6JZHP+pJScgvDZuuww96u4MXgRqCAAte15bLLYkqmuBcwW+zJBAV0mGvIfTcOggRBgWMIqiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779944888; c=relaxed/simple;
	bh=l2iOvBcoJDmh0ZIwG3NFWI2UyNWrIOFYxS5sViVnbaw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WiyJetjuCOLC324jw5y8GrvBbcVtzrzzg1rjfI9lP6dtFGbbc13Grpu/WNf7kJ+YpWojsE3KQw4BQkN5h1/Vmkgj4BOeRkfXBS82ibhq5/sWYpXSppVyKXeAq17kqBKnisLbQ6hgyen2D6RjxiT7QsrYAWyhQlGRyfDysUEwgQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HM9+bb4n; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=d8IRXh/t; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HM9+bb4n";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="d8IRXh/t"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S3GVg4325740;
	Wed, 27 May 2026 22:07:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=l2iOvBcoJDmh0ZIwG3NFWI2UyNWrIOFYxS5sViVnb
	aw=; b=HM9+bb4neRRc5fo1FmJMUtJQptq7hQr2ZFSd0KnBfkYtrBIQ8NaVw2qWJ
	Vsy01cAl7BFOhbbBl+2OtPF/pb9oHSACxGx2LEHEyjwlarzrlPA8Ero7krlXx7qN
	SwCgpOwYJbCkJWXnrMOLZGblm7wrAvjnsGgE2gUg+Uob3AFlJkYJ8Lx2fuI32aES
	dCx0JmE9cVrLZL4Z6DShMNbxbZJdJRRKz++pjyGRsT8EzUfw0fAbOMNEWQbWuFjS
	DB5cqlVdMIUTXMBwyOgNrkIVWeprWoS4EKXXjgmAs8yQyjk5v6PKDi86bnq3BrzF
	qVOdIVtSIXAHM08LGiMxcfVb6euyw==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020100.outbound.protection.outlook.com [40.93.198.100])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ee7wkrt64-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 22:07:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AE5bevXKaBkeHoNQCfdQM1uGnrHKPLzKNwF+WKpu3BAd0jNOqTlJGcegm8Vf4Q88uFRimFYqXgTq4COkEGiu1CMzgPbuMNVtprfg1PmsrBDnitCwbHPVxzL2kNGH/NpTVp0cduIt1jNd6smXPohmngcfafLa9waxgI8D6PoP6eJX+cmr6s8NxXoRLqge/2pvJLUHrtNleFrAMU2Ca9J483xabN+/BKsbiJ4YsEAL14Yxu9P+Co+1pQxLbADiGXxYOIIJkGiP5M/9e3dieYVIRPXoV/n58PXLfEuAw7HsPKDn1lQmd5mOmtlNlumgaDzolYpOCHAic3aDLFy4OaORLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l2iOvBcoJDmh0ZIwG3NFWI2UyNWrIOFYxS5sViVnbaw=;
 b=wPiohNBYzi0Q+vC2vemlubCoN2z16wQq94wgG4cuXJPsLIlzw9I1f99sZPwUq9UlOi4xOj1lEas99lLIGMk97lcFPOhDe0SFAap5d9+gBweIt/t+IesEB3IJ1p3ZqkbattdnjPhVLoBJ148yJNP8qVdnjgPQ4AfmPUNNnPWwVc+tRMLCibgcgA8JHtrvogE6WsmblGXsck0a0p4e7nosqxL2diUGhyHI/cp07yQC6/SqhkjgYYx6+ghr0LedjURx75qFqhsxKYlNlm4MijF2DRmYX9yUe7dXG3iMfdE9VvGynLptY5bRm4so5mE0FmZuvViyByBwZi+gfMhbDWNvWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2iOvBcoJDmh0ZIwG3NFWI2UyNWrIOFYxS5sViVnbaw=;
 b=d8IRXh/ts4phyteoXTKmmrNnWBLbzCvicvvrKYhIF1RlNWgEq6AqCKtHqKV+X8dWy2Otr8L/tnSXUP8WD7qRxHlPqniOm+v5+OudIv23mnHilL1UMTx5IE2GgG2WEhYYcsThrI0uGFWRViins6cGQZQ1RPvYsQa/P/y1I6Sdcfm4qMmk82e69jGdq2topJGgfaf20g+oDLWd0VbveocI37hbJ8Rv0L1zjgSafJkIFH7R7ETgdHMmIpiWQ93FO+P+352UwfQXGqxTW7zBj7oP2NFqxafIMxK6yYnZMmbLmxavFocCG7PZ/VeAbnTMPdqTn7qc/WdYwlLYzAjUGFYnlQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by PH0PR02MB11654.namprd02.prod.outlook.com (2603:10b6:510:3bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 05:07:48 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 05:07:47 +0000
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
Subject: Re: [PATCH v5 13/18] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Thread-Topic: [PATCH v5 13/18] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Thread-Index: AQHc55O5Scpifk99ukS97TxWxklCprYiBjUAgAAGyYCAAANEAIAACdSAgADWj4A=
Date: Thu, 28 May 2026 05:07:47 +0000
Message-ID: <47CCCA9C-EE35-4314-9619-50F28BFFB0AD@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-14-eric.auger@redhat.com>
 <3344B74E-39B1-421D-8417-373A688DB372@nutanix.com>
 <c4a38526-a803-4e69-b6ca-f6bf0583198a@redhat.com>
 <F50EB764-5F22-42AD-89E2-677BF7DB453B@nutanix.com>
 <63a8bd66-c324-4d2f-9d6b-1ea35e72db5b@redhat.com>
In-Reply-To: <63a8bd66-c324-4d2f-9d6b-1ea35e72db5b@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|PH0PR02MB11654:EE_
x-ms-office365-filtering-correlation-id: 4d647de6-5714-454e-5fe9-08debc770f2b
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|38070700021|3023799007|56012099006|4143699003;
x-microsoft-antispam-message-info:
 i85NKrALvOkS5OEqTE50oGJoVRDsC0nZtgSXWap9QaRNvaUgnePN4WPbMgIfFviOWj1yn214RORDStXKnXPwsl/4fXHVc2jxdCqTqcB+w2OkzKawg1QBSLMPFEgcOy2kppKVUA9KV2BoCZ8S8Lw8L5xkY/7byltGEHzY2+xUo1AaR/oI6gQu/bxNZshJBfGwJI3ol0X+OsvFcg9wj9Pb4Lg6U9eiJ61I0Rt1qcIrz+e0GmpHOjMZmLKuXIKh0McC47dr8XfvH55IM0zrpxrqUzcrDEYmwzllmRhAFXT1ig7cJDncns1rdap5TV3+KdnaNY9Ni5ZSm/J/wyhWkkdNgkZRffJw4klTHbiEsFeoxgXvprmqOy3a71A+LAgYEYeogD5gW6uvsLbEdVR+9D+WE+mqt+FXtXsK55XikQEbGAEUf3pdHtTQeNBViA72dbRyz7VOXp2HFSEvoEKpYzFLJxhfX+7QZXZ9yzFj87Zp+MiJ2Wi6Y6FhkxTFiWGEjGNE3+Z82qfyi3wzcWGOK2k4IiplsnI3Tfz8NcDxbRKhVJqhtcRfvKUJXu8CzSJTUxpzJT8nT1Ew1Gs4keFlEg5BUa8u86xbSzayWCZZLZDfguATbr3asQA6QH44vIMIdAEkXc242kOJe/8VKpkWkEQXiV0yVwhcLBYZRj3kV8hOKpgDTLn9dXC3Zq4g5BN5cdtSxb6raVWtWK4wH2RJksZdmejIy+uB18z3ezyIoU8JL44rx7ksIdiOA95K7N4V4TbJ
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(38070700021)(3023799007)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TnI0Y1BieE8xSGN5dmZ0NFRsL0JXRTMrZTg5VmwrMjZFQUpxSDN3Wi9QcTVJ?=
 =?utf-8?B?RmpNSHpsMXVUa3RkR2lRN1BRcGpiQ29aSG4xUDk1R092My9tVitjZXMzYWRC?=
 =?utf-8?B?MjI0N1VGUmxYSldoQ2J4T1Jsa0kzZWoyK3Y5UnF1S1Z1V0piVGZRTzNVWWhP?=
 =?utf-8?B?WTB5Rjl6RGt1d2g1VmhybHVqcWNXS0dSWFJpYkczcnRXWlJXNGpyVWpTOGZa?=
 =?utf-8?B?VWNaUnFUYmJQZE85YWIyeHR6T1g5QytDNXAzcnVOdkp1ZnVUbHYzWS9uWnFn?=
 =?utf-8?B?cmR0OTlvc0NyZUlBSngvRHdMSlcxTHZiTjQ1NCtvNVYrOGMzWU9PUnNVQldP?=
 =?utf-8?B?c1hKT3luZmdOWHFtd1VJN1VhaHk3NTk1bVFtSmFkd3FtbHVNbVVpZ0RiV1Rj?=
 =?utf-8?B?TUhSVS9mOE5ZNXBBcm9wakcrRWp0Uk0xYVFsS1VYRUVPdFA4RFZmTEtvb1ZO?=
 =?utf-8?B?M1MvU1JGb1dSR24rVHl6VnRldEZLc2FhSjZJMUhxSXlaUnVtRnYzbmFkTGYz?=
 =?utf-8?B?aWlCc3RWUVBaUlZKNlpuVWE0d3l3L0NLMUhWZkVXUGhGdXlSZjhjU0IxbUtC?=
 =?utf-8?B?OENjbTdXNVdabFB4Yi9xRE9SNThpQkR5NExPUWxNZ0tzRW9RUjQ5bS9pTjZT?=
 =?utf-8?B?L1JKRWF0ZFB6K1V4a0dFeXRYekZnU0hjZkdXd3lHc0hSRm1VQzJaZUNzVzNm?=
 =?utf-8?B?MFJ1Wm1ld2Myd1lhNC9zd0hvVXFkTG8yNUtaQ3FFZUZaSVpTUmNBK0YwL2hy?=
 =?utf-8?B?K2IrY1kyblQ0aFlMRUdwc1VZMzFESElmemZ0aU00U01IYkFJMG0vdUhNVXRE?=
 =?utf-8?B?SHJlcWJJcjlBdm5vTEdTeWFKYXpDWHoxcVpFNTcvelpXUUVKKzJudExMZFNT?=
 =?utf-8?B?VHZGUXQvL1hCTlhObGpFaTZyQzJMSjc2NjB4cEkxdjdtY1FuWllLYmdFb2pT?=
 =?utf-8?B?QUk2M1dsaTB2OVM0bDdVQ1dncktQd0dLdDN6ODJsMVZ0TFIzKyt6TUZOWmNN?=
 =?utf-8?B?UktpcmlFSERoQVY0ZXJzYi8wdk9nZlArR0xoOHNZY093L0FZeWIwNmRxeHpZ?=
 =?utf-8?B?RXFVc0RoWnNvZUdwVmtDU1RVc3JGeFVrUzFuK1JLd3lIbmZQblZSdHZzWnI1?=
 =?utf-8?B?SFhsR3VZRnFlNGNXNWs5S1JyL2xuNkxQNkEyTWQ4WTkwaXdCV2F3aThuNlp5?=
 =?utf-8?B?L01iUEw4R3MzUnkrcTBBWWxtUGh1UTd2UjV5YW45NVFQUUtyY1lLb2lWdjNC?=
 =?utf-8?B?a3VwQnk2WVl1MlN6S1k0cTVTZ1FEc3BxSEUyRXhDNEgrUWYyeWFoNGNHdFRy?=
 =?utf-8?B?Mm0yRlFWSzZYY1FDQ3B4UDZBeEFPWmNkYlJrUVArdTFEL0xMYkZzWkVVMWQr?=
 =?utf-8?B?YXk4UThvNkxZYVhqeFdlZ2lydzJjSEY0TzVTaHlvNkZnWlFoSENnaGZGWnd1?=
 =?utf-8?B?MFVGTjFyRFY4akJVMHNFMXg3OG1jQ1h3Q2UzK0dxWXJhblJ5UkZlNHBTcCsx?=
 =?utf-8?B?WkJHUXB0ODZoNDAvU0Z5R2d4RWw5UmlNbzhwZmVOSWJZUjByNUtvYVdMQVYx?=
 =?utf-8?B?ZHpyNS9EaEljWnRLWVFHb294MWNKRnZsRndPdTh5d01LTlMybVp0OXViZlZz?=
 =?utf-8?B?SzZsWWtvMDVtYVpmRk0ySkJxQnhQZDZ2Z290U3AzQlp0K3JvemZmaGk2T1Bu?=
 =?utf-8?B?RDB2YlVPMWRzTG5FSmtqSW4yMlNqRmw0bi94L0p1LzBqUzFFVFJJcEF3cWZv?=
 =?utf-8?B?NUozZ1B3SVJPQ2ZtL3d0QS9zRFlKQU1ZSU9ab3N2ZVBPL0ZBbzkrTTFTcldU?=
 =?utf-8?B?SlRmbGd5UjJOSFRBUWRRellPWlc3MHQrbFM2cDR5alVCL1pIeWh2eDV2bFBV?=
 =?utf-8?B?T2JxdHJzN29qR2VmaC81U3BOREZBY0MvUGRmWlRSQUZVZWNIMjdScHV5Rmxq?=
 =?utf-8?B?MEdwWkdQNkpQeFptMHRQeGQyUllmclVxeFUzWWErd3BmeGl2cmlYOGUxUHhR?=
 =?utf-8?B?TjhaaTllMDNqWVEyajlQRHpnRnBveE9hSkZ0S0l6SUtNVjltOGlMeCtKQkxp?=
 =?utf-8?B?TktCbVpGNC9CSkJLc01Rd1dPb0R5ZFVYOFFuejRpLzQvZ29uSUVOUCtaNFZE?=
 =?utf-8?B?T3lINVVMMkpjcWM4Q0MyMkRHcU9iL1BiNlhtMVBZa0tJb3Z6VjZDK0lKeWV3?=
 =?utf-8?B?a2FLcUh3MmFLby92RmxJeFJoSFFQN3dWb1ZrLzExd3hxU1ZYOFZxejZiNDhT?=
 =?utf-8?B?ME1YZ3VrSnZDcVZyN20vdmE2WVBQR2l1YUMwbGR4UDY5bGVtUHMwcHFHeXZP?=
 =?utf-8?B?anhiNHVzVFRwUHRma1cxSDF0dVNYbDg1TmhzSGs5T1ZQaFVrNUxDejM1SmtM?=
 =?utf-8?Q?VTORizY96zi+d2bw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E9AE6EC595BE049A2339E084DD75983@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	MnTat36wm+Hd/Wl1ZkV+h4OwhtKNoWHgnFalsz2P1tjC6NWopZfyqmyeyPzesOpXLAMBzmm79KvjQLkngnWRV6pu2fx26nYut5LPQeo+tu/arE+nM15wlRjLIBAnKLpFR53rVEHZmYf+liizGQBdx0h6V1giubDUrR0Sp7JurQ9n8gcES33FeXAKUMAnhRxiM44qHuqCM26yS4A5mizRN1zA6KEfIVMR1Ot3ahLHdGO/C45sle1VDKigg4gf7oqMs/nExJ0dAIEwYcqYHqPVrXXasTJzHGsi9uj0dauCy1hjCtxxlL841CzSO+iIJIfKqkFNHFptBAyrw6btxwvyGw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d647de6-5714-454e-5fe9-08debc770f2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2026 05:07:47.4663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aYg4rCJ4q0KYS9d9XGP6wbAVpj2TVUyqQ58pPirQEZJkswDCACm2E1LDyVcCYh0TemY3HVfeNiBnQJPu/0weRnG8OeLvxFKrP7IxFhHJb5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB11654
X-Proofpoint-GUID: RLyR3YiF0wDGqBTf1-bTgOXM5M38LqGm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDA0NyBTYWx0ZWRfXw3j+5S4WCL1X
 tLURMIperGPcScyw0J5GnrhPFTMVEWg2uZxQn2t166mvxxc2us8w7U+SVByHgi3B8EYbBpm/RXy
 wsntfQXf883WqcKjEAgqDjfpAzIOC/iAB9JCoaTHf3aoFMY8GizakXUmM9ilZFBOkGdhPLh648r
 zEcUcE6spdD1gF6LweVJUp1my4P2UqDl1SGGk8njP0Aqg8qEERanX1hGgrFznz+9ssdvEyMPC5w
 IcTRnjmiP1fCetcVmy303UDeuENjlteDacpJNryXUmlbjBbYalcV0iWHGM8i+4J1n/La1F2GLO7
 69xw+h2ZMk237fRv0mgrDd34tRiOr1IYd8lGcbyBPIGmc4IkHW5ZUMimxyp08cPEcuy0mdyOJyT
 bvV+RxiwWn3Gdse4f/46raNypuaUP32XDgnG2US2NfsDMw8XUopi+B3/yGi+KZP3ZgkU41avINA
 305v1mJgeCWWLgHFOOg==
X-Proofpoint-ORIG-GUID: RLyR3YiF0wDGqBTf1-bTgOXM5M38LqGm
X-Authority-Analysis: v=2.4 cv=WIVPmHsR c=1 sm=1 tr=0 ts=6a17cda5 cx=c_pps
 a=rsLXg5VPEOJQy+C7BNxFIQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=20KFwNOVAAAA:8
 a=bD22JI6vmj8lc3B2v7oA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_01,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjcgTWF5IDIwMjYsIGF0IDk6NDnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gDQo+IA0KPiBPbiA1LzI3LzI2
IDU6NDQgUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IA0KPj4+IE9uIDI3IE1heSAyMDI2LCBh
dCA5OjAy4oCvUE0sIEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+
Pj4gDQo+Pj4gSSByZXBsaWVkIHNlcGFyYXRlbHkgdG8gdGhpcyBvbiB5b3VyIHNlcmllcyB0aHJl
YWQuIEkgYW0gaW5jbGluZWQgdG8gZG8NCj4+PiBzbyBidXQgdGhpcyByYWlzZXMgYW5vdGhlciBw
cm9ibGVtYXRpYyBmb3IgdGhlIGxheWVyZWQgcHJvZHVjdHMgdG8ga25vdw0KPj4+IHdoaWNoIG1p
c21hdGNoIGNhbiBiZSBmaXhlZA0KPj4+IA0KPj4+IFRoYW5rcw0KPj4+IA0KPj4+IEVyaWMNCj4+
PiANCj4+IA0KPj4gSGVuY2UgdGhlIHNhZmUtdmFsdWUgdGFncyA6KSwgc25lYWsgcGVlayB0byB2
MiBvZiBSRkMsIHdpdGggc2FmZS12YWx1ZSB0YWdzLg0KPj4gRm9yIGVhY2ggcHJvcCB3ZSBjYW4g
c2F5Og0KPj4gICAgICAgIC4uLg0KPj4gICAgICAgIHsNCj4+ICAgICAgICAgICAgIm5hbWUiOiAi
ZmVhdF9SRE0iLA0KPj4gICAgICAgICAgICAic3VwcG9ydGVkLXZhbHVlcyI6IFsNCj4+ICAgICAg
ICAgICAgICAgICJvZmYiLA0KPj4gICAgICAgICAgICAgICAgIm9uIg0KPj4gICAgICAgICAgICBd
LA0KPj4gICAgICAgICAgICAidHlwZSI6ICJzdHJpbmciDQo+PiAgICAgICAgfSwNCj4+ICAgICAg
ICB7DQo+PiAgICAgICAgICAgICJuYW1lIjogImZlYXRfQVRPTUlDIiwNCj4+ICAgICAgICAgICAg
InN1cHBvcnRlZC12YWx1ZXMiOiBbDQo+PiAgICAgICAgICAgICAgICAib2ZmIiwNCj4+ICAgICAg
ICAgICAgICAgICJvbiINCj4+ICAgICAgICAgICAgXSwNCj4+ICAgICAgICAgICAgInR5cGUiOiAi
c3RyaW5nIg0KPj4gICAgICAgIH0sDQo+PiAgICAgICAgew0KPj4gICAgICAgICAgICAibmFtZSI6
ICJmZWF0X0NSQzMyIiwNCj4+ICAgICAgICAgICAgInN1cHBvcnRlZC12YWx1ZXMiOiBbDQo+PiAg
ICAgICAgICAgICAgICAib2ZmIiwNCj4+ICAgICAgICAgICAgICAgICJvbiINCj4+ICAgICAgICAg
ICAgXSwNCj4+ICAgICAgICAgICAgInR5cGUiOiAic3RyaW5nIg0KPj4gICAgICAgIH0sDQo+PiAg
ICAgICAgew0KPj4gICAgICAgICAgICAibmFtZSI6ICJmZWF0X1NIQTIiLA0KPj4gICAgICAgICAg
ICAic3VwcG9ydGVkLXZhbHVlcyI6IFsNCj4+ICAgICAgICAgICAgICAgICJvZmYiLA0KPj4gICAg
ICAgICAgICAgICAgInNoYTI1NiIsDQo+PiAgICAgICAgICAgICAgICAic2hhNTEyIg0KPj4gICAg
ICAgICAgICBdLA0KPj4gICAgICAgICAgICAidHlwZSI6ICJzdHJpbmciDQo+PiAgICAgICAgfSwN
Cj4+ICAgICAgICB7DQo+PiAgICAgICAgICAgICJuYW1lIjogImZlYXRfU0hBMSIsDQo+PiAgICAg
ICAgICAgICJzdXBwb3J0ZWQtdmFsdWVzIjogWw0KPj4gICAgICAgICAgICAgICAgIm9mZiIsDQo+
PiAgICAgICAgICAgICAgICAib24iDQo+PiAgICAgICAgICAgIF0sDQo+PiAgICAgICAgICAgICJ0
eXBlIjogInN0cmluZyINCj4+ICAgICAgICB9LA0KPj4gICAgICAgIHsNCj4+ICAgICAgICAgICAg
Im5hbWUiOiAiZmVhdF9BRVMiLA0KPj4gICAgICAgICAgICAic3VwcG9ydGVkLXZhbHVlcyI6IFsN
Cj4+ICAgICAgICAgICAgICAgICJvZmYiLA0KPj4gICAgICAgICAgICAgICAgImFlcyIsDQo+PiAg
ICAgICAgICAgICAgICAicG11bGwiDQo+PiAgICAgICAgICAgIF0sDQo+PiAgICAgICAgICAgICJ0
eXBlIjogInN0cmluZyINCj4+ICAgICAgICB9DQo+PiAgICAgICAgew0KPj4gICAgICAgICAgICAi
bmFtZSI6ICJmZWF0X05WIiwNCj4+ICAgICAgICAgICAgInN1cHBvcnRlZC12YWx1ZXMiOiBbDQo+
PiAgICAgICAgICAgICAgICAiMC4wIg0KPj4gICAgICAgICAgICBdLA0KPj4gICAgICAgICAgICAi
dHlwZSI6ICJzdHJpbmciDQo+PiAgICAgICAgfSwNCj4+ICAgICAgICB7DQo+PiAgICAgICAgICAg
ICJuYW1lIjogImZlYXRfUkFTIiwNCj4+ICAgICAgICAgICAgInN1cHBvcnRlZC12YWx1ZXMiOiBb
DQo+PiAgICAgICAgICAgICAgICAiMC4wIiwNCj4+ICAgICAgICAgICAgICAgICIxLjAiLA0KPj4g
ICAgICAgICAgICAgICAgIjEuMV9iYXNlIg0KPj4gICAgICAgICAgICBdLA0KPj4gICAgICAgICAg
ICAidHlwZSI6ICJzdHJpbmciDQo+PiAgICAgICAgfSwNCj4+ICAgICAgICB7DQo+PiAgICAgICAg
ICAgICJuYW1lIjogImZlYXRfTVBBTSIsDQo+PiAgICAgICAgICAgICJzdXBwb3J0ZWQtdmFsdWVz
IjogWw0KPj4gICAgICAgICAgICAgICAgIjAuMCINCj4+ICAgICAgICAgICAgXSwNCj4+ICAgICAg
ICAgICAgInR5cGUiOiAic3RyaW5nIg0KPj4gICAgICAgIH0sDQo+PiAgICAgICAgew0KPj4gICAg
ICAgICAgICAibmFtZSI6ICJmZWF0X0NTVjIiLA0KPj4gICAgICAgICAgICAic3VwcG9ydGVkLXZh
bHVlcyI6IFsNCj4+ICAgICAgICAgICAgICAgICIwLjAiLA0KPj4gICAgICAgICAgICAgICAgIjEu
MCINCj4+ICAgICAgICAgICAgXSwNCj4+ICAgICAgICAgICAgInR5cGUiOiAic3RyaW5nIg0KPj4g
ICAgICAgIH0sDQo+IEkgYW0gbm90IHN1cmUgd2hhdCB0aGUgYWJvdmUgcmVwcmVzZW50cw0KDQpU
aGlzIGlzIHRydW5jYXRlZCBvdXRwdXQgb2Ygc2ltaWxhciBxbXAgY29tbWFuZCBhcyBjcHUtbW9k
ZWwtZXhwYW5zaW9uLCB3aGljaCByZXR1cm5zIGZvciBlYWNoIHByb3Agd2hhdA0KdmFsdWVzIGNh
biBiZSBzZXQuIEZvciBleGFtcGxlIE1QQU0gaXMgbm90IHdyaXRhYmxlIGJ5IEtWTSwgaGVuY2Ug
b25seSBvbmUgc3VwcG9ydGVkIHZhbHVlIOKAnDAuMOKAnSwNCkNTVjIgb24gdGhlIGhvc3QgaXMg
b25seSDigJwxLjDigJ0gKGFyY2hpdGVjdHVyYWxseSwgMi4wIGlzIGFsc28gdmFsaWQpLCBoZW5j
ZSBvbmx5IOKAnDAuMOKAnSBhbmQg4oCcMS4w4oCdIGluIHRoZSBzdXBwb3J0ZWQgdmFsdWVzLg0K
DQo+PiAgICAgICAg4oCmDQo+PiANCj4+IA0KPj4gSSBhbSBpbmNsaW5lZCB0byBkbyBzbyBidXQg
dGhpcyByYWlzZXMgYW5vdGhlciBwcm9ibGVtYXRpYyBmb3IgdGhlIGxheWVyZWQgcHJvZHVjdHMg
dG8ga25vdyB3aGljaCBtaXNtYXRjaCBjYW4gYmUgZml4ZWQNCj4+IA0KPj4gSSBhbSB0ZW1wdGVk
IHRvIG1ha2UgdGhlIHNhbWUgYXJndW1lbnQgZm9yIHdyaXRhYmxlIGZpZWxkczogaG93IHdpbGwg
dGhlDQo+PiBsYXllcmVkIHByb2R1Y3RzIGtub3cgd2hpY2ggdmFsdWVzIGFyZSBzYWZlIChvciBl
ZmZlY3RpdmVseSBjYW4gYmUgc2V0Pyk/DQo+PiANCj4+IEkga25vdyByaWdodCBub3cgd2UgZG9u
4oCZdCBhZ3JlZSBvbiBrZWVwaW5nIHNhZmUtdmFsdWUgdGFncyBvciBkZWZhdWx0IHZhbHVlcy4N
Cj4+IEJ1dCwgSSBob3BlIHRoZSBhYm92ZSBpbmNsaW5lcyB5b3UgdG93YXJkcyBrZWVwaW5nIHRo
b3NlIDopDQo+IA0KPiBPSyBJIHRoaW5rIEkgbm93IHVuZGVyc3RhbmQgd2hhdCB5b3UgcGxhbiB0
byBkbyB3aXRoIHNhZmVfcnVsZSAod2hpY2gsDQo+IGFzIGZhciBhcyBJIHVuZGVyc3RhbmQgaXMg
bm90IGN1cnJlbnRseSBpbXBsZW1lbnRlZCBpbiB5b3VyIHYxKS4gV2l0aCBhDQo+ICJ0b29sIiBs
aWtlIA0KDQpZZXMgbm90IGltcGxlbWVudGVkIGluIHYxLg0KDQo+IA0KPiBxdWVyeS1jcHUtbW9k
ZWwtZXhwYW5zaW9uIHlvdSB3b3VsZCBiZSBhYmxlIHRvIHJldHJpZXZlIHRoZSBob3N0IHZhbHVl
LiBJZiBpdCBkb2VzIG5vdCBtYXRjaCB5b3VyIG5hbWVkIG1vZGVsIGRlZmF1bHQgdmFsdWUsIHlv
dSBjYW4gdXNlIHRoZSBzYWZlX3J1bGUgdG8gc2VlIGlmIGl0IGNvdWxkIGJlIGFwcGxpZWQsIHdp
dGhvdXQgcmVseWluZyBvbiBhbnkgc2NyYXRjaCB2Y3B1IGluc3RhbnRpYXRpb24uIFRoaXMgbWFr
ZXMgc2Vuc2UgaW4gdGhlIGNvbnRleHQgb2YgcHJvdmlkaW5nIHdheXMgZm9yIGxheWVyZWQgcHJv
ZHVjdHMgdG8gc2VlIHdoaWNoIHZjcHUgbW9kZWwgY2FuIGJlIHVzZWQsIGFzc3VtaW5nIHRoZXJl
IGlzIG5vIG90aGVyIHdheSBsaWtlIHNjcmF0Y2ggdmNwdSBpbnN0YW50aWF0aW9uLg0KPiANCj4g
SXMgdGhhdCBhIGNvcnJlY3QgdW5kZXJzdGFuZGluZz8NCg0KWWVzISEhIA0KDQo+IEkgdGhpbmsg
dGhpcyBpbXBsaWVzIHRoYXQgd2UgbmVlZCB0byByZXR1cm4gbW9yZSBpbmZvcm1hdGlvbiB0aG91
Z2ggcXVlcnktY3B1LW1vZGVsLWV4cGFuc2lvbiB0aGFuIHdoYXQgd2UgY3VycmVudGx5IGRvIChh
dCBsZWFzdCBpbiBbMV0gd2Ugb25seSByZXR1cm4gdGhlIHZhbHVlKS4gV2Ugd291bGQgbmVlZCB0
byByZXR1cm4gd2hldGhlciB0aGUgcHJvcCB2YWx1ZSBjYW4gYXBwbHkgb24gdGhpcyBob3N0IChp
dHMgZGVmYXVsdCB2YWx1ZSBpcyBzYW1lIGFzIGhvc3QgdmFsdWUgb3IgT0sgd2l0aCByZWdhcmRz
IHRvIGhvc3QgdmFsdWUgYW5kIHNhZmUgcnVsZSBhbmQgdGhlIElEIHJlZyBmaWVsZCBpcyB3cml0
YWJsZSkuIFRoaXMgbW9zdCBwcm9iYWJseSBtZWFucyB3ZSBuZWVkIHRvIGVuaGFuY2UgdGhlIHBy
b3AgdmFsdWUgdG8gY29udGFpbiBtb3JlIGZpZWxkcy4NCg0KU29ycnksIGRpZCBub3QgZnVsbHkg
dW5kZXJzdGFuZCB0aGlzLg0KDQpXYXJtIFJlZ2FyZHMsDQpLaHVzaGl0DQoNCj4gVGhvdWdodHM/
DQo+IA0KPiBFcmljDQo+IA0KPiANCj4gDQo+PiANCj4+IFdhcm0gUmVnYXJkcywNCj4+IEtodXNo
aXQNCj4gDQoNCg==
