Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C9445516A
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 07:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754861; cv=fail; b=qT+4xzgPbeOOUYUM53Gn7Y+OiBwAu8KZ5Nn2hE1oxrIxPetu+O4p2l8MhafYFqmPdW08R9JEmQxtx5Q7z2VMgx3DbZiHpAUDMmYNwNT3cXcLEsjgk2cUVTavRLM5sp/kkS5lzhdVKpxGrDNDotIXV8GNlkiF0EFxLRABNUy+nco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754861; c=relaxed/simple;
	bh=4nrCBnBqYEhnQEMGj14lcT7K0Uj+aqL/lQXRiqgFDqs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fGj4v7eiAO5qHM4ZJhj9K2ZGfmIlzdtDgXwG4av9OQQEO2aIT/xr+Sdbmbhe35dmcOiyuXsCJOI6m9RHxB5yo5maSzQnHuJ27t6Qye9rFh+ZHm53L5WJPh6URyaPuxZnJuizjekPYhVaI3fsjAo4S7OoFI3Twazxls72O7kbGYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mibuLBH8; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=eeb6bJB/; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mibuLBH8";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="eeb6bJB/"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68U7c4KJ2884953;
	Wed, 30 Sep 2026 00:54:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=4nrCBnBqYEhnQEMGj14lcT7K0Uj+aqL/lQXRiqgFD
	qs=; b=mibuLBH8Z3BK8A38Zo8mTSzLkAoPxd5ux81kFi/YnSCDFqd6UFuSGiraE
	sY8Gn5oGTRnhXcV78lclVWAFcxZZuaTto4io3wjeJmsNEwoZGhiYF5lbMHXnygqf
	8W9PGvRmLhrv3FPWvd786WwHC1AkL90JvdfYv/TTrG6bigSXJel49y2/z5iiylcI
	o8LzKkq5g4BfMJQAFEPIE0xfwfKq2ivCobDobJJ84v948YU+5S8O9u5cgS9Lmh2S
	8x3lk2ppjuWMtiS/BQjjkIRNDp87eo4OL3wAhRUibx6IbCKleKo2UJjpvzHwmmau
	i3Ja9G5+8ik/HUQMqAvbV3z1LZV8A==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022080.outbound.protection.outlook.com [40.107.209.80])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4h0n0k19kb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 00:54:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wmg4gR9lhv9UlTjuJQU2tqbBVxPM8eqa1wJmS9WrsLO4Df8HFG94kxF4t/EJeP1qqj48SGQOAJp5UCrvp75PcAk06TYDX0r+uahAwNYdjAo/SZHO/xIk/USIAEj7Uc7L/ZLtPLtoAXFjWeKiHkV+EYDym6LNWkPAV9fC8z2DqwnM5rKpXRtemvoBk0MpfdoJ2cTiKf6e27KZb4rDZG7FkJMnMHAHX21Rwv9lZCRZCV6cxRXQGsfvnDaLw30AE4pk0via2VU0hXOLKVdfC6Xn989XNCT/ocXSo+7RlPd1Hbj4fBL7iiUBlZpGCeAZyM6Pc6QURB/WhkqZvnuxInamQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nrCBnBqYEhnQEMGj14lcT7K0Uj+aqL/lQXRiqgFDqs=;
 b=NfH20Bn707VgXSqkPmZMTnlrlVbfln168s93qcoCfeIrZP0vMXwDe1BWycQEdmwGDP3zk0xiiBE3VzBrlpEmbXVNZ+Rwm5Vh9JrJrN6OCEk/jcgJJ6GMWYInQC9vVSz1N1Tqm0AXVVOW2ZAQl/l7ASDQ3G/+QYB+Tl/IOBD6bttEEwe38FdfTcKu0Sh1ivYDKO9dJvYkgnk4iHEsSt+SRtEMu5Ipl9iYVS5PJ4zHVMX3QOd+CDNsM0eak1X6WjkaPAihH+ocmxuHTEbcqe/yBPJDaVnruZg7J5YHtA4tw6kVD391F0wBALp01UfG0R+heL09CY+zmZmlBy6UV+k3aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nrCBnBqYEhnQEMGj14lcT7K0Uj+aqL/lQXRiqgFDqs=;
 b=eeb6bJB/1xDub0PH2++uXprS6WlRTE7uXL4Mkka8EAgo9LiBGLJ1dtHLUmYmmtFk6NawLBY6s2eClwUHnRZMW3u6iPeE0gJ9KqDCqCiiZmmArfifg+2SWbpuUo+GX8FNBJEzhTyZfUZxlP/NtqCXYr/lFCJXIuV2LtlmcgdyKscgUDMXtgFE0zweFaisUPk3FHRdtTXOpZD82Tf+Jv4INbFGelFMQOfoYtxY7YyVJvEd0TdvK17vEJBZILXp0VSpbC5bymGtKv1KdA6kUQXnD7t+CEWCZ+HAQH7GNrd7PDtJIgBnkhch0BqKrEnFnoqI68NmRn9zf7eFe9HU3bjQHA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by PH0PR02MB7656.namprd02.prod.outlook.com (2603:10b6:510:4d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 07:54:00 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 07:54:00 +0000
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
Subject: Re: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
Thread-Topic: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
Thread-Index: AQHdULDa2ssfTnSUDk65rlAE1JPetA==
Date: Wed, 30 Sep 2026 07:54:00 +0000
Message-ID: <5AC3258F-1F6E-491E-8B38-633C52199904@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-17-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-17-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|PH0PR02MB7656:EE_
x-ms-office365-filtering-correlation-id: f4b0a853-28e2-41d3-f713-08df1ec7fd1f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|38070700021|4143699003|3023799007|10067099003|56012099006|5023799004|22082099003|18002099003;
x-microsoft-antispam-message-info:
 ZIoFanxheaab0lIhbw9Maq7TL3MBbxiU7LLCWVacEW+tYiwwkmCzI8nHi72LAW1CDplsVfgQK6XtJtDZbqEmXR72ULAbDfPOlBpBlEArnLx3HBAErxIHTGXaQUir3KM5RE1smS6JP1CfQGt2Kcvbu3YAnUcrjnCSZ7u3hW4T/RVrITt6WWGkoQ+h/tnePQ6sxsm32UQ2IJ/0N/0f4fFzdCNG+zVhfOoiabkD57BfU9gTer3MItBvC0msHkxBjzZDhj/m4bqUxuJ8BFyIvInRcrNOOrCH1UorJfPkg57fs9oKm/PmZWjGATLPLnFLMUrHi5OeRWR098HA22BVQhKKpVuuvvVkqvOdicLPE3BF4g3hQvLZ+7EBUCh2Xd3u0+ojJrh07F3tQ/0tAxCFPQ7LBk50+WAN0laY6cWluFnC0Jg7Cqr26PlrdRKt0GtCocteL8+iobawxxx7Y0M2qSOs+q+45ZqmhMLYKtgN1r54v38Hg+zCt0O33IqxMVhD3lOOpAk/vE063uUn5ZmG8SQQzgsNVRmsix8zZuRQICA1E84fvjA9d2yZp+8h1am9s1wpOXEhgk+YRfvzu3TzvR3J0OpYH3KpuuB+7Cxm+8uV8gMWhp0sqKfow2s3RTdlvB8s6SUT5D7J0i5XExaH/MMfFLf2wnkjLXGtIAZ/h+Zclqn0QHOY93chCQvjDGxqu75frt0OO7wZ1pw+k7SjD01ugWTg93s15GuENwQlI4AdreM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(38070700021)(4143699003)(3023799007)(10067099003)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VDVBWEhSaHBBQURuVlc3SEVwZXhiQVU1Yzh2WjdxeHRweXJ1bGxUb0NqMjhy?=
 =?utf-8?B?cTNlMWN3QzFJa2E2bFE3enVPLzhobnBISzA5c2tMMnBFM040bmFnQkpqSkxp?=
 =?utf-8?B?eGJsUTBlTEhhZWJhS1F3YXF3emY0STdzUStTbS9mRHFMZlk5M2hPSXorc3Y4?=
 =?utf-8?B?cktJMHlpTC9na0FjZm9QSUNhZk9KV3VPaVhqbVByeThjK05wVTBnTnFLS1E4?=
 =?utf-8?B?eVZkM3BBY0NGa0Y3WkpVTjl4a1BUcm5Rb2Ird1o5VWVBRjd4MUV2eTlCdmdX?=
 =?utf-8?B?QWtqQ2hzM0xWRERjWTlEc2prcmJQQWFEVEhGZVJzanZSRkdRY1lIK3ZLa3lR?=
 =?utf-8?B?RUNzNldaM0YzNVU1RGxHbzJDR0FiTnBLdXBUY0UwUUVNSTg1SldUWlllR0pN?=
 =?utf-8?B?MlprM3JZbXRvUEZiakhEYlVDSUtVNEVwS3VrbHJ4K3VMdEtCRHJpQXVwTkRR?=
 =?utf-8?B?Zy9IdUtMVlQyMEFEYzRtcUNwVlM0dlp1TUNjdmNDT2srT0FXSmR4ZFJJL1N2?=
 =?utf-8?B?Wnl2bm5jNG92cmdTVEJTNXVuQ2oxZ00wQ2JaSG9VeTFzUW8rNXZpRjl3UHJ2?=
 =?utf-8?B?SWErSHpEQ1NvcWcwR1MvVjFDc3ZWL0ZibDVyS29kK3EwTUdiZkVYdEdOV3lN?=
 =?utf-8?B?am1ONXUwT0dtTVo3Q3FzMEpBcEhjQ25yVmJqZG41dVRlbFM4Z2hRWHdTck5K?=
 =?utf-8?B?eWZ6MDVSVG5POU9GZVJiMTZUN1R0bXZKQlNPVnJJaTRqalpsK3Y4eG1ta250?=
 =?utf-8?B?eXJDdHVzeTFDZ0RnUGEwV1pRU2xHNjBZaHY5NzdvOUxCbjQ2SUlIZ3NIWDZO?=
 =?utf-8?B?WUF3ai9vR0JZV2JHVER2TDl2dGtIbGhPaDljSHBGcW5LUGVrVVlTUmNSSk1O?=
 =?utf-8?B?K1ZNRkpyRmFyWkYvU0NmN1BOVzJJMDJZL3JaZ1BpRW10aWV4WmRIVDhyQUc3?=
 =?utf-8?B?WnJEZzRJdjRzUFhtd01MY2p4VUlaM1dZcVlnN2sxcW1DL2JFNzR1V25BbU1X?=
 =?utf-8?B?SjUzTjlRN01sZE80ejkwVzJ3RVJnL0ptYzlPRndQMXFOWS9yaEkvTTFKQ1J1?=
 =?utf-8?B?aHZ5YlhjWmZGV2dHUGlmUExoZzdheDBibTVOeTllUXpsenpyaC9ZMHBvTDhp?=
 =?utf-8?B?ODVaYkd4czFjcEJwWW9tdTBUdXdvNG5UejE1SWVHdVRqZTk2TndFcmJBeTk0?=
 =?utf-8?B?OEErNTM3Qmowak53aTdwZ3k0eWVSSDNxUW8rZVdPUWxLN3dyeWlETlJYSHRx?=
 =?utf-8?B?TVUyM01sVkJzQUlmdXhhNEE2Wm1HTk5KKzA1dGZMY1FCOXo0WmNyTEo1OVhV?=
 =?utf-8?B?bFp6RFZxUEFzVFo0T2ZCUmJ3cUZZQ004dWNLdTFlWmNaa3VqcERzT1Y3TUw5?=
 =?utf-8?B?NUEwd3hUT2N3eVVrV1NjYnZnZEwzUE9XWkVLb3A2SWVCREtZN1NKcDBEUXk5?=
 =?utf-8?B?T3RzOGZONXlxdEpaNVExY3VDWWVEaDNySXJjMGhWaVVMc2h1YTArL2k4aDho?=
 =?utf-8?B?b0hSSTRvazEwdEJWYTN1SXNPb3BGbSt2WDgwVnFMWnlCaTRLUFh6ZklENUkw?=
 =?utf-8?B?a0dSNENTRnVrZjVmdzhVTmRZbHdMZ3ZiUndFcVV4bmo3MHk4akJHWjNFZWQ2?=
 =?utf-8?B?MVJwUXFCSFVJMExjVWlJQ3JDRGI0K01YVXNXTWN2R2lUL1JqR0lqYzFHMlho?=
 =?utf-8?B?Vmd0bkxJTmFOTU91cVNGeWVXSUh1M0w1dEtFRFNQY0xKR2RFam9MNlRSZnBy?=
 =?utf-8?B?YzF3WUNvU21DSFdHcmkrQnRhNTQ1U0U1TDJYZU83dEVzNElZKzlMakZFdGNS?=
 =?utf-8?B?cTNRRlRZbDVWb2VtYkdEVFJpazVEKzJhRTg2ZUp0OE1CTE1UNEtZM2J6STRq?=
 =?utf-8?B?OC9xY01na2pjSllBMjN4dWZCWkFIcDExNEh3UGUwdHprSE1YWGM5aW9HNEN5?=
 =?utf-8?B?WTUrNzdZYm8rUUZ6dTNPbDRPeUZid0wzR2tFUW9kVllMTEQ1aDRqTnZyRTNs?=
 =?utf-8?B?eFFDM084ZGxYYms1ZWtMYkRaSHltenUwWXVYaEpwR25wODdRY2M0aGQ1V1lu?=
 =?utf-8?B?UHk4alM1RUp4NGx5NHhET0I1b1V5NnM5WENQYnlEWFVReFRCRTVsSGRtL3RL?=
 =?utf-8?B?MHFVOXhnQ3o1bEYxWWdjVnZ1d1BRbHhqYnRiU2tXWmVmM1ZaQ2N1UzNYZEJu?=
 =?utf-8?B?RmdYVXhtTjJONVRmTk40ZHZncXFhTXZMRkRTaUMvNkZhbEJhNlJhZ01QTk9y?=
 =?utf-8?B?TGNUU2Jyd25iVlo5Mm03L0lzclc0RHpkNjJmc1h4N25XUnFVRmZhTTMvYkhT?=
 =?utf-8?B?L1BKMVhoWkh4YTZkRkkwN2dPZ0xDSmptampCK3E1eUd1K3lZVStLRExoWlBH?=
 =?utf-8?Q?iE1PMJtG8KngSZig=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D63BAE1395C0AF439D13110BD3AF3D4F@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	cC0gYNv0FWYZYtQSv4mlNM5mruPVdN43Byf3tsH7lp44gD25XEkbtbvzl4ANuScPjf0tSgNxphqY30MJ8I9+VxwDObWc9klggjF+y4kq2Z+Nj6axLopHX7xTz1VHtxE8jPd36hMPSBVGGSefmoo9BT06OPBCKqG6Iogq0L2ly+lfw72YOeSbC70rGJITKl8Q45FA+W6cQKug6XneDfNkhNHqv9Rxa37HfGzySgPbx/ubsWcPy+gaSvCVY+CSeVDVUEOivDoZjd5BUBPRUlDJenCMl18EWHB1b8jkcqmqu2vZoVV2FrulizAr/Ldo9lzWvEQTafPnJxn6BfqVSUfnsQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b0a853-28e2-41d3-f713-08df1ec7fd1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2026 07:54:00.3799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0G8rLkMgUnqKX/YlH+oNirpgSzn92H9mY3WaOrnicEYMgjZud1v075OnPJ+SZNUUzvI2QHykwILpUwxTt6WV9qy+ZWpz8v92o00tAWsT4u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7656
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDAzMSBTYWx0ZWRfX+MUF+zBSDhSv
 r7siuHfzsl6FPavm0+LaNYKwrl1aN7vc171Agip+auSeQwC3WrytQogDp3cukerhnaEWog1F5fP
 lr+MSiLecMkvkLbkQ9kTY71/zWoqZ38=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAzMSBTYWx0ZWRfXywl0bGtAeiUz
 iVJiYZigZbMpy0K6TdLJuhulWU7Ecd8zhSczcuZkbgSISJNQKaTqRb+YgwUVEcqVQqpv1G8tEdW
 F03Uw8zXTE/cgjPYpyJGqt8UWA+awVUbf5AA3peJjaxl9Hdq22qv4gCNQtG6+2gtWmnFnhITDlN
 gkpRChHC8oMuYTCy41+hUyrhWvpf+TSIi8darHsd1CxQY//Mn8njhAIJCb3g8aiQ7LrdKoT64yH
 1f72UFP3ZVLMUC0OJJDY+hqZ2+qepIvlRUQ5J8V7Ur7zyfTqdDmry548hVNQZ21AMuE3XVIciqd
 Q6hHOPz2uNMNdQOcjgrfIsRdBMccRGAVnoOFk6mmKPtThmew2lSxHXSLI8mE+tnXztd602vjz4B
 dcBMhBBAOxCRIIWg7/NMqSuHjvW0qLHHMbJSdUvWWcUeOfOWURCvCsCDVBprNSy/cf7csR2WObi
 cP/ah9Uo5YljX+Vxnlw==
X-Authority-Analysis: v=2.4 cv=I9Hw19gg c=1 sm=1 tr=0 ts=6abcc01a cx=c_pps
 a=12vGVFQirf4vZIp7c/z4DQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=Q_m8maRGB1xC1OxrJScA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Xn-fiV0VKa1-DeUMhmVSDOXRKhFvPod6
X-Proofpoint-GUID: Xn-fiV0VKa1-DeUMhmVSDOXRKhFvPod6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gU1lTUkVHIHByb3Agc2V0dGlu
Z3Mgd2VyZSByZWNvcmRlZCBpbiBhIGhhc2h0YWJsZSBidXQgdGhleQ0KPiBhcmUgbm90IHlldCBp
bmplY3RlZCBvbiBndWVzdC4gSXRlcmF0ZSBvdmVyIGFsbCBzZXQgZmllbGRzIGFuZA0KPiBhcHBs
eSB0aGUgbmV3IHZhbHVlIHRocm91Z2ggS1ZNX1NFVF9PTkVfUkVHLiBUaGUgbmV3IGZpZWxkDQo+
IHZhbHVlIG92ZXJyaWRlcyB0aGUgY3VycmVudCBvYnNlcnZhYmxlIHZjcHUgcmVnaXN0ZXIgdmFs
dWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5j
b20+DQo+IC0tLQ0KPiB0YXJnZXQvYXJtL2t2bS5jICAgICAgICB8IDY1ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+IHRhcmdldC9hcm0vdHJhY2UtZXZlbnRzIHwg
IDEgKw0KPiAyIGZpbGVzIGNoYW5nZWQsIDY2IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1n
aXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPiBpbmRleCAzZWMyNjE4
Y2MxLi5kZGYzMjBkMGU2IDEwMDY0NA0KPiAtLS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+ICsrKyBi
L3RhcmdldC9hcm0va3ZtLmMNCj4gQEAgLTM0Myw2ICszNDMsOSBAQCBzdGF0aWMgQVJNNjRTeXNS
ZWdGaWVsZCAqZ2V0X2ZpZWxkKGludCBpLCBBUk02NFN5c1JlZyAqcmVnKQ0KPiAjZGVmaW5lIE1B
S0VfSURSRUdfS0VZKHJlZ19pZHgsIGZpZWxkX3NoaWZ0KSBcDQo+ICAgICAoKCh1aW50NjRfdCko
cmVnX2lkeCkgPDwgOCkgfCAoKHVpbnQ2NF90KShmaWVsZF9zaGlmdCkgJiAweEZGKSkNCj4gDQo+
ICsjZGVmaW5lIEtFWV9UT19SRUdfSURYKGtleSkgICAgICgodWludDMyX3QpKCgodWludDY0X3Qp
KGtleSkpID4+IDgpKQ0KPiArI2RlZmluZSBLRVlfVE9fU0hJRlQoa2V5KSAgICAgICAoKHVpbnQ4
X3QpKCgodWludDY0X3QpKGtleSkpICYgMHhGRikpDQo+ICsNCj4gc3RhdGljIHZvaWQgc2V0X3N5
c3JlZ19wcm9wKE9iamVjdCAqb2JqLCBWaXNpdG9yICp2LA0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgY29uc3QgY2hhciAqbmFtZSwgdm9pZCAqb3BhcXVlLA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgRXJyb3IgKiplcnJwKQ0KPiBAQCAtMjIxNSw2ICsyMjE4LDYzIEBAIGlu
dCBrdm1fYXJjaF9wcmVfY3JlYXRlX3ZjcHUoQ1BVU3RhdGUgKmNwdSwgRXJyb3IgKiplcnJwKQ0K
PiAgICAgcmV0dXJuIDA7DQo+IH0NCj4gDQo+ICtzdGF0aWMgaW50IGt2bV9hcm1fYXBwbHlfc3lz
cmVnX3Byb3BzKEFSTUNQVSAqY3B1LCBFcnJvciAqKmVycnApDQo+ICt7DQo+ICsgICAgdWludDY0
X3QgKmlkcmVncyA9IGNwdS0+aXNhci5pZHJlZ3M7DQo+ICsgICAgZ3BvaW50ZXIga2V5X3B0ciwg
dmFsdWVfcHRyOw0KPiArICAgIENQVVN0YXRlICpjcyA9IENQVShjcHUpOw0KPiArICAgIEdIYXNo
VGFibGVJdGVyIGl0ZXI7DQo+ICsNCj4gKyAgICBnX2hhc2hfdGFibGVfaXRlcl9pbml0KCZpdGVy
LCBjcHUtPnN5c3JlZ19wcm9wcyk7DQo+ICsNCj4gKyAgICB3aGlsZSAoZ19oYXNoX3RhYmxlX2l0
ZXJfbmV4dCgmaXRlciwgJmtleV9wdHIsICZ2YWx1ZV9wdHIpKSB7DQo+ICsgICAgICAgIHVpbnQ2
NF90IGtleSA9ICh1aW50NjRfdClrZXlfcHRyOw0KPiArICAgICAgICB1aW50NjRfdCB2YWx1ZSA9
ICh1aW50NjRfdCl2YWx1ZV9wdHI7DQo+ICsgICAgICAgIHVpbnQzMl90IHJlZ19pZHggPSBLRVlf
VE9fUkVHX0lEWChrZXkpOw0KPiArICAgICAgICB1aW50OF90IGxvd2VyICAgID0gS0VZX1RPX1NI
SUZUKGtleSk7DQo+ICsgICAgICAgIEFSTTY0U3lzUmVnICpyZWcgPSAmYXJtNjRfaWRfcmVnc1ty
ZWdfaWR4XTsNCj4gKyAgICAgICAgc3RydWN0IGt2bV9vbmVfcmVnIGt2bV9yZWc7DQo+ICsgICAg
ICAgIHVpbnQ2NF90IGN1cnJlbnQsIG9sZCwgbWFzazsNCj4gKyAgICAgICAgdWludDY0X3Qga3Zt
X2lkeDsNCj4gKyAgICAgICAgQVJNNjRTeXNSZWdGaWVsZCAqZmllbGQgPSBnZXRfZmllbGQobG93
ZXIsIHJlZyk7DQo+ICsgICAgICAgIGludCBsZW5ndGggPSBmaWVsZC0+bGVuZ3RoOw0KPiArICAg
ICAgICB1aW50NjRfdCBvbGRmdjsNCj4gKyAgICAgICAgaW50IHJldDsNCj4gKw0KPiArICAgICAg
ICBtYXNrID0gTUFLRV82NEJJVF9NQVNLKGxvd2VyLCBsZW5ndGgpOw0KPiArICAgICAgICB2YWx1
ZSA9IHZhbHVlIDw8IGxvd2VyOw0KPiArDQo+ICsgICAgICAgIG9sZCA9IGlkcmVnc1tyZWdfaWR4
XTsNCj4gKw0KPiArICAgICAgICBrdm1faWR4ID0gaWRyZWdzX3N5c3JlZ190b19rdm1fcmVnKGlk
X3JlZ2lzdGVyX3N5c3JlZ1tyZWdfaWR4XSk7DQo+ICsgICAgICAgIHJldCA9IHJlYWRfc3lzX3Jl
ZzY0KGNzLT5rdm1fZmQsICZjdXJyZW50LCBrdm1faWR4KTsNCj4gKyAgICAgICAgaWYgKHJldCkg
ew0KPiArICAgICAgICAgICAgZXJyb3Jfc2V0ZyhlcnJwLCAiZmFpbGVkIHRvIHJlYWQgdGhlIGN1
cnJlbnQgdmFsdWUgb2YgJXMiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICByZWctPm5hbWUp
Ow0KPiArICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gKyAgICAgICAgfQ0KPiArICAgICAgICBv
bGRmdiA9IChjdXJyZW50ICYgbWFzaykgPj4gbG93ZXI7DQo+ICsNCj4gKyAgICAgICAgaWRyZWdz
W3JlZ19pZHhdID0gY3VycmVudCAmIH5tYXNrOw0KPiArICAgICAgICBpZHJlZ3NbcmVnX2lkeF0g
fD0gdmFsdWU7DQo+ICsNCj4gKyAgICAgICAga3ZtX3JlZy5pZCA9IGt2bV9pZHg7DQo+ICsgICAg
ICAgIGt2bV9yZWcuYWRkciA9ICh1aW50cHRyX3QpJmlkcmVnc1tyZWdfaWR4XTsNCj4gKw0KPiAr
ICAgICAgICByZXQgPSBpb2N0bChjcy0+a3ZtX2ZkLCBLVk1fU0VUX09ORV9SRUcsICZrdm1fcmVn
KTsNCj4gKyAgICAgICAgaWYgKHJldCkgew0KPiArICAgICAgICAgICAgZXJyb3Jfc2V0ZyhlcnJw
LCAiZmFpbGVkIHRvIGFwcGx5IG5ldyB2YWx1ZSAweCUiUFJJeDY0IiBmb3IgZmllbGQgJXMuJXMg
Ig0KPiArICAgICAgICAgICAgICAgICAgICAgICAiKHByZXZpb3VzIGlzIDB4JSJQUkl4NjQiKTog
JW0iLCBpZHJlZ3NbcmVnX2lkeF0sDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJlZy0+bmFt
ZSwgZmllbGQtPm5hbWUsIG9sZGZ2KTsNCj4gKyAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ICsg
ICAgICAgIH0NCkhpIEVyaWMsDQoNClRoZSBhYm92ZSBpcyB0aGUgb25seSBLVk0tcmVsYXRlZCBj
b2RlIGhlcmUuIENhbiB3ZSBzcGxpdCB0aGlzIGludG8NCiAgICAxLiBBcHBseSBTWVNSRUdfIHBy
b3BzIGNhbGxiYWNrIHdoaWNoIHJlc2lkZXMgaW4gY3B1NjQuYz8NCiAgICAyLiBUaGUgcHJldmlv
dXMgd3JpdGViYWNrIHRvIGNwcmVncyBmdW5jdGlvbiB0aGF0IHdyaXRlcyBiYWNrIElEIHJlZ2lz
dGVycyB0byBLVk0/DQoNClRoZSByZWFzb24gYmVpbmcgdGhlIFNZU1JFR18gcHJvcHMgb3RoZXJ3
aXNlIGRvIG5vdCB3b3JrIHdpdGggYW55IG90aGVyIGFjY2VsZXJhdG9yLg0KV2UgYXJlIGFscmVh
ZHkgdHJ5aW5nIHRvIG1ha2UgdGhlIFNZU1JFR18gZ2V0dGVyL3NldHRlciBhY2NlbC1hZ25vc3Rp
Yy4NCg0KVGhlIGFib3ZlIG1ldGhvZCBzdGlsbCBoYXMgdGhlIG5pY2V0eSB0aGF0IC1jcHUgaG9z
dCB3aXRob3V0IGFueSBTWVNSRUdfIHByb3Agc2hvdWxkDQpiZWhhdmUgdGhlIHNhbWUgYXMgcHJl
dmlvdXMgOikNCg0KU2lkZSBub3RlOg0KV2hpbGUgd2UgZG9u4oCZdCB0YXJnZXQgVENHIHN1cHBv
cnQgY3VycmVudGx5LCBJIHRyaWVkIHlvdXIgdjggKyBuYW1lZCBtb2RlbHMgb24gVENHDQoocXVp
Y2sgaGFjazsgfjIwIExPQyksIGFuZCBTWVNSRUdfIHByb3BzL25hbWVkIG1vZGVscyB3b3JrcyBh
bG1vc3Qgb3V0IG9mIHRoZSBib3gNCnRoZXJlICh2ZXJ5IG1pbmltYWwgdGVzdGluZyksIHdoaWNo
IHdhcyBjb29sLg0KDQpUaGFua3MsDQpLaHVzaGl0DQoNCj4gKw0KPiArICAgICAgICB0cmFjZV9h
cHBseV9zeXNyZWdfcHJvcChyZWctPm5hbWUsIGZpZWxkLT5uYW1lLCBvbGQsIGN1cnJlbnQsDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1hc2ssIHZhbHVlLCBpZHJlZ3NbcmVn
X2lkeF0pOw0KPiArICAgIH0NCj4gKyAgICByZXR1cm4gMDsNCj4gK30NCj4gKw0KPiBpbnQga3Zt
X2FyY2hfaW5pdF92Y3B1KENQVVN0YXRlICpjcywgRXJyb3IgKiplcnJwKQ0KPiB7DQo+ICAgICBp
bnQgcmV0Ow0KPiBAQCAtMjMxNSw2ICsyMzc1LDExIEBAIGludCBrdm1fYXJjaF9pbml0X3ZjcHUo
Q1BVU3RhdGUgKmNzLCBFcnJvciAqKmVycnApDQo+ICAgICB9DQo+ICAgICBjcHUtPm1wX2FmZmlu
aXR5ID0gbXBpZHIgJiBBUk02NF9BRkZJTklUWV9NQVNLOw0KPiANCj4gKyAgICByZXQgPSBrdm1f
YXJtX2FwcGx5X3N5c3JlZ19wcm9wcyhjcHUsIGVycnApOw0KPiArICAgIGlmIChyZXQpIHsNCj4g
KyAgICAgICAgcmV0dXJuIHJldDsNCj4gKyAgICB9DQo+ICsNCj4gICAgIHJldHVybiBrdm1fYXJt
X2luaXRfY3ByZWdfbGlzdChjcHUpOw0KPiB9DQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2Fy
bS90cmFjZS1ldmVudHMgYi90YXJnZXQvYXJtL3RyYWNlLWV2ZW50cw0KPiBpbmRleCBkNzJhZDZi
NjcxLi5iNGQyYjQ1YTdkIDEwMDY0NA0KPiAtLS0gYS90YXJnZXQvYXJtL3RyYWNlLWV2ZW50cw0K
PiArKysgYi90YXJnZXQvYXJtL3RyYWNlLWV2ZW50cw0KPiBAQCAtMTgsNiArMTgsNyBAQCBrdm1f
YXJtX3dyaXRhYmxlX2lkcmVnc190b19jcHJlZ19saXN0KGNvbnN0IGNoYXIgKm5hbWUsIHVpbnQ2
NF90IHByZXZpb3VzLCB1aW50Ng0KPiBkZWNvZGVfaWRyZWdfd3JpdGVtYXAoY29uc3QgY2hhciog
bmFtZSwgaW50IGxvd2VyLCBpbnQgdXBwZXIsIGNoYXIgKnByb3BfbmFtZSkgIiVzIFslZDolZF0g
aXMgd3JpdGFibGUgKHByb3AgJXMpIg0KPiBnZXRfc3lzcmVnX3Byb3AoY29uc3QgY2hhciAqbmFt
ZSwgdWludDY0X3QgdmFsdWUpICIlcyAweCUiUFJJeDY0DQo+IHNldF9zeXNyZWdfcHJvcChjb25z
dCBjaGFyICpuYW1lLCB1aW50NjRfdCBvbGQsIHVpbnQ2NF90IG1hc2ssIHVpbnQ2NF90IGZpZWxk
X3ZhbHVlLCB1aW50NjRfdCBuZXcpICIlcyBvbGQgcmVnIHZhbHVlPTB4JSJQUkl4NjQiIG1hc2s9
MHglIlBSSXg2NCIgbmV3IGZpZWxkIHZhbHVlPTB4JSJQUkl4NjQiIG5ldyByZWcgdmFsdWU9MHgl
IlBSSXg2NA0KPiArYXBwbHlfc3lzcmVnX3Byb3AoY29uc3QgY2hhciAqcmVnX25hbWUsIGNvbnN0
IGNoYXIgKmZpZWxkX25hbWUsIHVpbnQ2NF90IG9sZCwgdWludDY0X3QgY3VycmVudCwgdWludDY0
X3QgbWFzaywgdWludDY0X3QgZmllbGRfdmFsdWUsIHVpbnQ2NF90IG5ldykgIiVzLiVzIG9sZD0w
eCUiUFJJeDY0IiBjdXJyZW50PTB4JSJQUkl4NjQiIG1hc2s9MHglIlBSSXg2NCIgbmV3IGZpZWxk
IHZhbHVlPTB4JSJQUkl4NjQiIG5ldz0weCUiUFJJeDY0DQo+IG5iX3N5c3JlZ19wcm9wcyhjb25z
dCBjaGFyICpuYW1lLCBpbnQgY291bnQpICIlczogJWQgU1lTUkVHIHByb3BlcnRpZXMiDQo+IA0K
PiAjIGNwdS5jDQo+IC0tIA0KPiAyLjUzLjANCj4gDQoNCg==
