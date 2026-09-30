Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1188C3955C6
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 07:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753704; cv=fail; b=L+dTPkhv6NLZ6Pquen1bMtu7k6iYi662oWjxzw5cFlnqa6hMJU/hk8OWf8o2ld+8kAV6fl++kj4c9UQgH6FugVs9qlPLnu7eDXZY169h3oyXv3Fv6xDh6GwoUBtST18fjChZTcUEnLcVWPsQYkMDQT1K9R2qguEp8zMsSnkbmEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753704; c=relaxed/simple;
	bh=Z29PConBpEqTk3YZ7kbgRTkDuIpJcYT1XMhhUPoZKMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bb0/jMHFjZu3ObjD/rzyslrDKzjW9s/ESWJNj4rIR9YqGnTieEV1jxVzWJNEHgT+M5XvTHzAKHxi6RWCoj3EIE1NKfLyxTDkvPlvpz5GTmwvXcK1Pk1v2AHSi4kObadqYQ0pBKl2tdkHxoIbWwAuL+rH+0+4qSzcj3MrH3dk530=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Ph2KouIh; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rN+1HIdV; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Ph2KouIh";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rN+1HIdV"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TNSg8u1830717;
	Wed, 30 Sep 2026 00:34:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Z29PConBpEqTk3YZ7kbgRTkDuIpJcYT1XMhhUPoZK
	MI=; b=Ph2KouIh0U22ikWnxeNPP7AJ8l28Exu8yEvhhKHIc4ZDu90J1dh1Dh547
	X2HxrGuuhTWbJfnmdr9wpjwJnIFRyKZyNGEKzUV8aqOcJxuzXeMeplxyZJW2Ca9F
	3FqDQTQaCSZm50VIWWto8ArhFAH4KizPuTymcTc84T6fRuf6y/YsO9Jjlz+PHpl2
	Rd/zKOa/bdmKpEW9UOI0Yg+wi/tKPpqAGYa7PEg/8Kg6kqGhhtesCXDtjB6ssBMr
	9+h4NmvYtJkH7zVU/w0WQ2Q8S4bj8qFKVgKAOl6bklllpbRKWVoyOfkn+vdNRNK8
	PN1vGeFJwRzWmyK6wvRDelUBhX/Zw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020077.outbound.protection.outlook.com [52.101.201.77])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4h0n0k183s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 00:34:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OmrBrvfOq/ExpUwPEVcUxiFi8CUQ+h1CrEy25+IPhSUYoJa7YwgXoBxevXmCBHV3QCJi4slx/nYMLLGBiuo1Vaj7I7YDCIyNOPFI4L0N8ShSRY8wipsmqMa9Lb5k1W64EOsXd8ZJH+7k1uC4koucMjiGVFyUZHoDf/sDDadAzF4M5YEogaLcEXRHUlU3huvmXmXV5SUiSY4riHhd9uSEgKbrU+pDhmbRqF43aiueVRGsML7tm66DNWV2OeFuMYSQzxEKulSrNTAVgQcbLzCSw8isC6qtvnXZCTYxnpqGcjvPVsgJDtWFK/Lc2iTMK1RiA9qNVxhUkL4qt/PpaZTQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z29PConBpEqTk3YZ7kbgRTkDuIpJcYT1XMhhUPoZKMI=;
 b=VDbfrJp5K8/ID3E9jskcNZyx96P79mbiLkZ4GWa2nwMcvovepjSo/p9VRLi/uvwTg3kNaXYAF9+hV9YWJqWWrrmvMddyhbIbe647snfGi9Dp/t151ZxcdTIqgSyOINwDt+PC9TtBATLSCNvvXa+t5aVIgK5dRBOkhXyPV+gy65hlqGAYJhNz28pIsQD6/jtoACe0zl69501H6O47bGb2MJh7JWPgMxX5lXmF8B4Ocvlpn0O5hcObD4VPNewtlUcFCNrm6Mz97usWDlue9vaDc1UMbk+Gk+j/ZFCoijSigpJwJ169rdymNtI3xfRHR+kPKyyxe6CODVVyJ2yUsjXIaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z29PConBpEqTk3YZ7kbgRTkDuIpJcYT1XMhhUPoZKMI=;
 b=rN+1HIdVIHW0pC5Y8nVZVsHd/n0tqN4ouIm6BdjmJiZ+kJHvk+V6sFCQoKzSWiehrjh4oo9qVGlog1SOGW7+HFqQack0ZOisKkRefefRNeBnlMGzXIwXiAK+BH2SUAuaI8+rD2JBJI6E7VIbKRQXXdwKkG6xMwj5QIgfRUbrND6kkGoJ3AzWOvY8nVNa5xA1ZBdv9eMWW0L5gWn1QbpbHkrZW4sddydw3alUhMQjqnPMk5BW1wj5EV97gT5hSvE7fvx98VLxKJpij7UaI2PQ+Ah+/VIGmq5D/UtOiGiDEMXb1sxYlbxL77xrU+RTB687OaZ3BbugTWo3HZj1WvNKaA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by IA3PR02MB10721.namprd02.prod.outlook.com (2603:10b6:208:514::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 07:34:45 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 07:34:45 +0000
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
Subject: Re: [PATCH v9 17/26] target/arm/kvm: Add consistency checking for
 SYSREG props
Thread-Topic: [PATCH v9 17/26] target/arm/kvm: Add consistency checking for
 SYSREG props
Thread-Index: AQHdUK4pQscVFUpKHEiJoipL3InJuQ==
Date: Wed, 30 Sep 2026 07:34:44 +0000
Message-ID: <CECAE32E-9A75-4D8D-827D-9F25D026F364@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-18-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-18-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|IA3PR02MB10721:EE_
x-ms-office365-filtering-correlation-id: e0a6d61d-9e97-45a5-75fa-08df1ec54c74
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|38070700021|6133799003|56012099006|10067099003|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 F/c6Dp5S+ao4PnEmPzSfkUTPabvKrIUMTVetbwKCAs4uGoQxCd5ZVyNICYT/xBF5/MukHj2QPFZ3++h+aIyn2nG3rItyDcvy7Jq4t08FJdCVE+/2U+RWWHyMkCBcxJPx9zQsgraC6YNnCKlTkjU4SmT+CFGHQcyZh3E1sVCWQ9BIcY13kXD1RyNqlp5HzMotoIQPck3JOmdreXlMBo4fGNFc5ryyRSq3OwGevOYAHDe/G9UQSEDJHupHs90twR4nE0HJ3g2fZ09w24+xrd04ZG5OmvkqcoVfbOLKgP9O2leRUGNdFrTiSHpkS1Oq6X9xRWW8ygV9Q1nCPEEvFeWks5xYvejm6A81HzEmICEygD1q+8/UpW277ZjL1tA48VEuvm3B4M58dJ13lpaloQtq7HLC4eg/GAOncfkbioAutc8jkS+vwAWZiAsEdJPdI/0m1JHim5LFuP77l+W/Sx0c/lWhuUiO69Kwtoyl5UJfM2L42yJrLHs/lYnPAoD/5RRLDDece6G6W3lHw14yU6fjWSgo3oH09dM7fsbXpFccix+XCqZnL4mx4nZOWO5kn0YqrIL4MMMGuxGm2H3He+UlzoVfd3JSyQCnJl9XwkMkq6vehl9wxTkDXXvuH2n1msErZNgmqz2LJXJzdq31Kew/YT68HJRbHvWtZzyhJKo0cSAx+fIu+dhDOGppdaiCsuTPUJWrlWBOovqgWoVsSl3KftRMquyPVBl4SObkCDWJyq0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(38070700021)(6133799003)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QWtpSk0rbXVXTmMrSnNXajlsS2dFdzhkaER3ZXJVeXNmR1JrMkJtQmRkcEVQ?=
 =?utf-8?B?bkREb1RjYzh3SUE4L0lNeVlJcEY3ckVFSGRGcWxBUnJxSXZybW50N3lqSDdj?=
 =?utf-8?B?NG5tVS90Z3NyMGhZWnFYajNDWisvdTB6RTljVVp2R3h1LzBHeGlMWHlmTmM5?=
 =?utf-8?B?ZU00Sy9WZGpvRHd0OFhhZXBVbTVqZk85dnNYR1h2V20zd2JiOE1xY1VCS3Ey?=
 =?utf-8?B?UHd0MzlhQkY5RWpsMlUwQk83dUNWblovSmFEWVBWbjR2MnZHelNwUVNwSmVK?=
 =?utf-8?B?Tnc2c1daejhkS0pNSXBicmVmUTRoN0xkTENrYnNaZFBVQmZwT1RTeTJoNU1Z?=
 =?utf-8?B?S2daamliVFNIS1RXeTBwVFFlVmUrclBnMnY1eWZGRUJsVDBMUlpDVEdhM1ZB?=
 =?utf-8?B?a1Z5cURhSXhxYzdzT3A5VFAzV2dDWC9QRnhFMHZDZUluZGxRdVJvZXU0TlhB?=
 =?utf-8?B?eFg1TFZBWk5rTGZKVW9NeHNqVXpmQlpYMWN3UitkVFBCMm1CNlZvUERIaGc2?=
 =?utf-8?B?bGVLQXFZMUhkQVlHdE5iZEhiY0ZqYkNVR1ltWTN4SEszcFBIdy8zK0REQWc5?=
 =?utf-8?B?YlBZdHJFT0VSMW9lVHpVMG9aVkRIMkpCaG4rVVlldktVdHlUU3RRTG1wTzNM?=
 =?utf-8?B?eHVrcSswQUJGeHBFNkNWN29SekoxdmpLM2ROSGdQc2ZpWEVTNUJTUVpMVUJN?=
 =?utf-8?B?Z0Y5c3R4aFNNaUt6Vk14eG9SMXhPcFBkL2JqZytVaWpBNDdmZm1kY3RmUk91?=
 =?utf-8?B?NkFIdW9US3B1YmxlMmpjN2ZvY0NVL0NObzlnS2lFTHRMQlo1VEo0SmJBRFpK?=
 =?utf-8?B?U3huWG15c2F0U2QwbUpidCs4MWM0LzlxbUtlQzIxbGI5VnVOR3I5Nk1KOHd3?=
 =?utf-8?B?UE5XeUt4STRRRm1ubFpoMXZoMU5qMEpNWFBPVENwUkhGSHBUQTF3UTBPSmh5?=
 =?utf-8?B?U3VmQ21rdHg3ZmxtR2hNRUhnUElKdmgySWdrUzJ4VG5rN2tveG9zRTZ1MEdh?=
 =?utf-8?B?dTlBcWg4RVdKN3crbXdkMUxFS0lCME05UUlGRjNYalI0NW03VmZWUFN1bnhj?=
 =?utf-8?B?UEo1c1hkaXhtRlB5YTZ0Y2NkZVN1U0R3bGJQUkpLUDJPUkdQTk9aYzltZFRv?=
 =?utf-8?B?K2JlUTU5Yk9JK3piVDdyYjBmVVFZU2FlZSsxeG1DZithRzNlbVlpa0d2d2t5?=
 =?utf-8?B?alg3NVpqZnZ5ZitEeGl3YnhIYWxvR0RZaG9pT3NYWlhHbUdOeWl0Ymdkck9h?=
 =?utf-8?B?YmJxYTI1ZTVwMzlhZFllMjladmR1ZG5uNlVhZm16NnEvU2IzM3FlNXFFaUR4?=
 =?utf-8?B?UGdPdDFzVW5PMGZKR0tkRU5NQ21RL3lGUEFWK0xTcDFYMmYzaG9WU1h3SjN4?=
 =?utf-8?B?Qk5kOWd4M0s3cGFzR1FhN2NXb2RWVDJPYW5XTTRYN3JrR0RzdDJNbnN6MWVh?=
 =?utf-8?B?QkN3K3g5dTZ3KzhSTkFITzc5b0t0VG5qb2gyeDVTTHpiRjNkajFEL1M5NDNM?=
 =?utf-8?B?ZGJyQmJ2Y0h6cElkZmxEeG5ZakEwTHAraVdDNE1jdXlqWW55ejNSZlg4N0dx?=
 =?utf-8?B?VzM4K2xHMzNmeTJWQ3BiSnVrcXo1NTY4WWVlRzVBc3l2MWRmYksxQWJOU3A3?=
 =?utf-8?B?cGUzT1htN1JqSExtVnplY2YreDZzREF3RXlkT3IzWXpRMXVoTm1yWkhWNEwr?=
 =?utf-8?B?eTNuYmlhWHArcFlNeWN1NVdJWEE3dWhpVjFXdFVhT09aVFZrUGF1TUEyaWlW?=
 =?utf-8?B?SEJqRGNzQWcwdVN6ZVl6VHZiY1ZiY0NlMHdmeGFuNUwxYU1ZT0dxYjAyZnU1?=
 =?utf-8?B?OEhzUEZkQW4wT0pqR2cyaHo5bkZFRDZYTmVVb0ZKVGhFYU9keDhTZ0V4V2lU?=
 =?utf-8?B?K3hWVHo5V29KRGtZRUJ0RTI2akpZUm1uU0VUM3VtTlRpVXJvdFJVN2tTd0c5?=
 =?utf-8?B?ckhuVTJCYXY0Q3pleVYycWFzTjFkSlNQZElINVlkd1J4blVQYWpHajRTTXNZ?=
 =?utf-8?B?VEM0VFpGeTRQSURGMFZPdmprQTl0am1oNlQ2djFkM0FCK3lsOGNmcTN5Y2F5?=
 =?utf-8?B?R1A1YStFY01VTDZyTXAzQkV5MXhjUGhBQkx3bTBqNlNvTE5xVFZzL2pidmxR?=
 =?utf-8?B?d0thNmxHd3Y5S0Q4enVydW4vayt4dTBDSkQyRnFGWXloWlBwMWFLU2V3a3gx?=
 =?utf-8?B?RmFZTzErdFRiRnNCdysyNStmczdrenJBNU9nY3hMOXcwN0N3MmtheVVVQ3lO?=
 =?utf-8?B?L0FGcGk4bmdkdjE1T3E4VzM5RlA2Y2NWK2NOTUgyWnZLTW9WdTFFeXZOR25V?=
 =?utf-8?B?cnNmaXZqOE5FZVpqaW9QUEJua3R0d0VKeXR3K0E0V3gyYytHSG9JdlRPeUFo?=
 =?utf-8?Q?jBh7wTx2E2ert4cU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BBFDCC0C8CEE6478BF187F2990A1746@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	M2cKyHfA8A3dPd487bU1PfLTJRN4mQKMIiC5TRt6I6zTK60H+YkphQ1Forku/1ROH3uKsUkftsJb9J2wqOMpmdnqiYpwF7rz96HcasR9aSNfjpjI/QcR0u07tAnaVXF7SOM/Qa0ELgy1mqBCL8u1FM1JrDDoYVCo112v55KrLghBh+nEfjZOekcEIYdx5wc+qT6KKstlplBOr5waAOY3a/tlnOgMIZvJtRcle/j9HYbWso2oDurUlGASgthmwaEONR9f4LldjinnY447q4jRDcvxpRG5Fq7cA14BJU1PviaBk6FqS0lSgqaEVnwzIXC9DZOP+wjuDAMb0ZdVNjD/Pg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a6d61d-9e97-45a5-75fa-08df1ec54c74
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2026 07:34:44.9752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ppk/hhFeJX7E8NAa8zuEchVc4kNdGfmKjbeyZ2ZzwdlJdRCh2CTbSmffY/JnULmT6Zypv3jmaoZgo1SKHSJyb1eaPakQVI8658SeBoX6bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR02MB10721
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDAyOSBTYWx0ZWRfX30OJymQj6jph
 jDAxe0A99LXP3JFlwp7Ur3kuy999txfxMn2aFmsHQnU3Vw1SDWT87Ri09Uj8qHid4ZNn4hpj909
 yiUUa/54Uf6/q4pr1fDmD036/uQKC9c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAyOSBTYWx0ZWRfX2l1QYeb/yedH
 jTJ88rHTbiEpJ3UoEURBle2reWn+4Oj4iscdZmN+rreyoJLsxghYVRSvVIUKRZ1/TyHBwwNRb/s
 f5HQzFWMVnREJsgD0xQLMGcti4+QbOZg5C+/YKBsEd1ska32DRrYt5RWbygg4SkdjNCJ7l/GdmE
 0y8awd8wrfQF/E4Oonr2kNtjRZCkxlauVo+MTvyWZ37jfLUdtee3HGEiER1X7TbEjWUUPFhCRB7
 6AkE1wRqGSCFvlqeFX34kB2KAPnJ6ckZihASmzARg/xwV0vcgB72tYdq+kbGrQoR2+ep/Zam+23
 mLCSBO1tDXV/dLMe4bPhC9WiEZ3gJ5hkGXnpbJHp6ndshSa67JGX6W0uAErxgBOBRKmpD5cEEcO
 T3bIdZHgjBrIgLSMDWiHv/B3CYxChdnrnToaXHOi56+SdneqozhIQgM5VXOVhB6KKyNLcWotm7x
 0q5Oz76iip/N4qu6UuA==
X-Authority-Analysis: v=2.4 cv=I9Hw19gg c=1 sm=1 tr=0 ts=6abcbb97 cx=c_pps
 a=xIT6qh1QoVJP9/0AGxBiIw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=QzcX_fuCNwpz-PptuLcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MQZCNGiu9rUTaJZ2e9rtYd-o9HoSDJku
X-Proofpoint-GUID: MQZCNGiu9rUTaJZ2e9rtYd-o9HoSDJku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gU2luY2UgbGVnYWN5IGNvbXBv
c2l0ZSBvcHRpb25zIChzdWNoIGFzIFNWRSwgdmlydHVhbGl6YXRpb24sIC4uLikNCj4gYW5kIG5l
dyBTWVNSRUcgcHJvcHMgY29leGlzdCwgYWRkIHNvbWUgYmFzaWMgY29uc2lzdGVuY3kgY2hlY2tz
Lg0KPiANCj4gVGhvc2UgY2hlY2tzIGFyZSBwZXJmb3JtZWQgYm90aCBpbiBrdm1fYXJjaF9pbml0
X3ZjcHUoKSBiZWZvcmUNCj4gYXBwbHlpbmcgdGhlIFNZU1JFRyBwcm9wcyBhdCB0aGUgZW5kIG9m
IHRoZSBpbml0aWFsaXphdGlvbiBjaGFpbi4NCj4gDQo+IFNvbWUgSUQgcmVnIGZpZWxkcyBjb3Jy
ZXNwb25kaW5nIHRvIGxlZ2FjeSBjb21wb3NpdGUgb3B0aW9uIHNjb3BlDQo+IGFyZSBub3Qgd3Jp
dGFibGUuIEluIHRoYXQgY2FzZSB3ZSBqdXN0IGNoZWNrIHRoYXQgdGhlIGZpZWxkIGhhcw0KPiBu
b3QgYmVjb21lIHdyaXRhYmxlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJp
Yy5hdWdlckByZWRoYXQuY29tPg0KDQpIaSBFcmljLA0KDQpHYXZlIHRoaXMgYW5vdGhlciBsb29r
LiBJIHN1Z2dlc3QgbW92aW5nIHRoaXMgdG8ga3ZtX2FybV9leHBvc2VfaWRyZWdfcHJvcGVydGll
cygpLg0KV2hhdCBJIHN1Z2dlc3Qgc3BlY2lmaWNhbGx5IGlzOg0KLSBIYXZlIGEgbGlzdCBvZiBJ
RCByZWdpc3RlciBmaWVsZHMgd2hpY2ggY29uZmxpY3RzIHdpdGggbGVnYWN5IHByb3BzLg0KLSBp
biBrdm1fYXJtX2V4cG9zZV9pZHJlZ19wcm9wZXJ0aWVzKCkgKHRoZSBuZXcgZmllbGQgYmFzZWQg
YXBwcm9hY2gpIG5ldmVyIGV4cG9zZSBmaWVsZHMNCiAgd2hpY2ggYXJlIHBhcnQgb2YgdGhlIGFi
b3ZlIGxpc3QuDQoNClRoaXMgd2F5IHRoZSBzYW1lIGNvbnNpc3RlbmN5IGxvZ2ljIHlvdSBoYXZl
IHdpbGwgY2Fycnkgb3ZlciB0byBuYW1lZCBtb2RlbHMgYnkganVzdCBhZGRpbmcgZGlmZmVyZW50
DQpzZXR0ZXJzIGZvciB0aGUgYWJvdmUgZmllbGQuDQoNCldoYXQgYXJlIHlvdXIgdGhvdWdodHMg
b24gdGhpcz8NCg0KVGhhbmtzLA0KS2h1c2hpdA0KPiDigJQgDQo+IHRhcmdldC9hcm0va3ZtLmMg
fCAxMDUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4g
MSBmaWxlIGNoYW5nZWQsIDEwNSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGFy
Z2V0L2FybS9rdm0uYyBiL3RhcmdldC9hcm0va3ZtLmMNCj4gaW5kZXggZGRmMzIwZDBlNi4uZjUy
YzAzNzQ1ZSAxMDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS9rdm0uYw0KPiArKysgYi90YXJnZXQv
YXJtL2t2bS5jDQo+IEBAIC0zNDAsNiArMzQwLDEwNyBAQCBzdGF0aWMgQVJNNjRTeXNSZWdGaWVs
ZCAqZ2V0X2ZpZWxkKGludCBpLCBBUk02NFN5c1JlZyAqcmVnKQ0KPiAgICAgcmV0dXJuIE5VTEw7
DQo+IH0NCj4gDQo+ICsNCj4gKy8qKg0KPiArICoga3ZtX2FybV92Y3B1X3ZhbGlkYXRlX3N5c3Jl
ZzoNCj4gKyAqDQo+ICsgKiBWYWxpZGF0ZSBhIFNZU1JFRyBmaWVsZCB2YWx1ZSBpcyBjb25zaXN0
ZW50IHdpdGggbGVnYWN5IGNvbXBvc2l0ZSBvcHRpb25zDQo+ICsgKiBTb21lIGNoZWNrcyBhcmUg
bm90IGltcGxlbWVudGVkIGJlY2F1c2UgdGhlIGNvcnJlc3BvbmRpbmcgc3lzcmVnIGZpZWxkDQo+
ICsgKiBpcyBub3QgY3VycmVudGx5IHdyaXRhYmxlLiBJbiB0aGF0IGNhc2Ugd2UgbWFrZSBzdXJl
IHRoZSBmaWVsZCBoYXMgbm90DQo+ICsgKiBiZWNvbWUgd3JpdGFibGUsIHdoaWNoIHdvdWxkIG1l
YW4gdGhlIHVzZXIgaGFkIHRoZSBjYXBhYmlsaXR5IHRvIHNldCB0aGUNCj4gKyAqIGNvcnJlc3Bv
bmRpbmcgcHJvcGVydHkuDQo+ICsgKg0KPiArICogcmV0dXJuIHRydWUgaWYgY29uc2lzdGVudC4g
ZmFsc2UgaWYgaXQgaXMgbm90LCBhbG9uZyB3aXRoIGFuIGVycm9yIGhhbmRsZQ0KPiArICovDQo+
ICtzdGF0aWMgYm9vbCBrdm1fYXJtX3ZjcHVfdmFsaWRhdGVfc3lzcmVnKEFSTUNQVSAqY3B1LCBB
Uk02NFN5c1JlZ0ZpZWxkICpmaWVsZCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgdWludDY0X3QgdmFsdWUsIEVycm9yICoqZXJycCkNCj4gK3sNCj4gKyAgICBj
b25zdCBjaGFyICpmaWVsZG5hbWUgPSBmaWVsZC0+bmFtZTsNCj4gKyAgICBBUk02NFN5c1JlZyAq
c3lzcmVnZGVzYyA9ICZhcm02NF9pZF9yZWdzW2ZpZWxkLT5pbmRleF07DQo+ICsgICAgY29uc3Qg
Y2hhciAqcmVnbmFtZSA9IHN5c3JlZ2Rlc2MtPm5hbWU7DQo+ICsgICAgZ19hdXRvZnJlZSBjaGFy
ICpwcm9wbmFtZSA9IGdfc3RyZHVwX3ByaW50ZigiU1lTUkVHXyVzXyVzIiwgcmVnbmFtZSwgZmll
bGRuYW1lKTsNCj4gKw0KPiArICAgIC8qIHZpcnR1YWxpemF0aW9uICovDQo+ICsgICAgaWYgKCFz
dHJjbXAocHJvcG5hbWUsICJTWVNSRUdfSURfQUE2NFBGUjBfRUwxX0VMMiIpKSB7DQo+ICsgICAg
ICAgIC8qIGNvbnNpc3RlbmN5IHdpdGggbWFjaGluZSB2aXJ0dWFsaXphdGlvbiBwcm9wZXJ0eSAq
Lw0KPiArICAgICAgICBpZiAoY3B1LT5oYXNfZWwyICYmIHZhbHVlID09IDApIHsNCj4gKyAgICAg
ICAgICAgIGVycm9yX3NldGcoZXJycCwNCj4gKyAgICAgICAgICAgICAgICAiSW5jb25zaXN0ZW50
IC1tYWNoaW5lIHZpcnR1YWxpemF0aW9uPW9uIGFuZCAiDQo+ICsgICAgICAgICAgICAgICAgIiVz
PTAiLCBwcm9wbmFtZSk7DQo+ICsgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAgICAg
IH0gZWxzZSBpZiAoIWNwdS0+aGFzX2VsMiAmJiB2YWx1ZSA+IDApIHsNCj4gKyAgICAgICAgICAg
IGVycm9yX3NldGcoZXJycCwNCj4gKyAgICAgICAgICAgICAgICAiSW5jb25zaXN0ZW50IC1tYWNo
aW5lIHZpcnR1YWxpemF0aW9uPW9mZiBhbmQgIg0KPiArICAgICAgICAgICAgICAgICIlcyA+IDAi
LCBwcm9wbmFtZSk7DQo+ICsgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAgICAgIH0N
Cj4gKyAgICAvKiBzZWN1cmUgKi8NCj4gKyAgICB9IGVsc2UgaWYgKCFzdHJjbXAocHJvcG5hbWUs
ICJTWVNSRUdfSURfQUE2NFBGUjBfRUwxX0VMMyIpICYmIHZhbHVlID4gMCkgew0KPiArICAgICAg
ICAvKiBjb25zaXN0ZW5jeSB3aXRoIG1hY2hpbmUgc2VjdXJlIHByb3BlcnR5ICovDQo+ICsgICAg
ICAgIGVycm9yX3NldGcoZXJycCwgIiVzIGlzIHNldCBidXQgcWVtdSBpcyBub3QgcmVhZHkgdG8g
c3VwcG9ydCBpdCIsDQo+ICsgICAgICAgICAgICAgICAgICAgcHJvcG5hbWUpOw0KPiArICAgICAg
ICByZXR1cm4gZmFsc2U7DQo+ICsgICAgLyogTVRFICovDQo+ICsgICAgfSBlbHNlIGlmICghc3Ry
Y21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRQRlIxX0VMMV9NVEUiKSkgew0KPiArICAgICAg
ICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBub3cgZXhwb3NlZCBidXQgcWVtdSBpcyBub3QgcmVh
ZHkgdG8gc3VwcG9ydCBpdCIsDQo+ICsgICAgICAgICAgICAgICAgICAgcHJvcG5hbWUpOw0KPiAr
ICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAgLyogU1ZFICovDQo+ICsgICAgfSBlbHNlIGlm
ICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9TVkUiKSkgew0KPiAr
ICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBub3cgZXhwb3NlZCBidXQgcWVtdSBpcyBu
b3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+ICsgICAgICAgICAgICAgICAgICAgcHJvcG5hbWUp
Ow0KPiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAgfSBlbHNlIGlmICghc3RyY21wKHBy
b3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRaRlIwX0VMMV9TVkV2ZXIiKSkgew0KPiArICAgICAgICBp
ZiAoY3B1X2lzYXJfZmVhdHVyZShhYTY0X3N2ZSwgY3B1KSAmJiB2YWx1ZSA9PSAwKSB7DQo+ICsg
ICAgICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJzdmUgaXMgc2V0IGJ1dCAlcyBpcyBzZXQgdG8g
MCIsIHByb3BuYW1lKTsNCj4gKyAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICAgICAg
fSBlbHNlIGlmICghY3B1X2lzYXJfZmVhdHVyZShhYTY0X3N2ZSwgY3B1KSAmJiB2YWx1ZSA+IDAp
IHsNCj4gKyAgICAgICAgICAgIGVycm9yX3NldGcoZXJycCwgInN2ZSBpcyBub3Qgc2V0IGJ1dCAl
cyBpcyBncmVhdGVyIHRoYW4gMCIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHByb3BuYW1l
KTsNCj4gKyAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICAgICAgfQ0KPiArICAgIC8q
IFBBVVRIICovDQo+ICsgICAgfSBlbHNlIGlmICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lE
X0FBNjRJU0FSMV9FTDFfQVBBIikpIHsNCj4gKyAgICAgICAgLyogUEFVVEggUUFSTUE1IGFkZHJl
c3MgYXV0aGVudGlmaWNhdGlvbiAqLw0KPiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBp
cyBub3cgZXhwb3NlZCBidXQgcWVtdSBpcyBub3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+ICsg
ICAgICAgICAgICAgICAgICAgcHJvcG5hbWUpOw0KPiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+
ICsgICAgfSBlbHNlIGlmICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRJU0FSMV9F
TDFfQVBJIikpIHsNCj4gKyAgICAgICAgLyogUEFVVEggSW1wbCBEZWZpbmVkIGFkZHJlc3MgYXV0
aGVudGlmaWNhdGlvbiAqLw0KPiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBub3cg
ZXhwb3NlZCBidXQgcWVtdSBpcyBub3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+ICsgICAgICAg
ICAgICAgICAgICAgcHJvcG5hbWUpOw0KPiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAg
fSBlbHNlIGlmICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRJU0FSMV9FTDFfR1BB
IikpIHsNCj4gKyAgICAgICAgLyogUUFSTUE1IGdlbmVyaWMgY29kZSBhdXRoZW50aWZpY2F0aW9u
ICovDQo+ICsgICAgICAgIGVycm9yX3NldGcoZXJycCwgIiVzIGlzIG5vdyBleHBvc2VkIGJ1dCBx
ZW11IGlzIG5vdCByZWFkeSB0byBzdXBwb3J0IGl0IiwNCj4gKyAgICAgICAgICAgICAgICAgICBw
cm9wbmFtZSk7DQo+ICsgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICB9IGVsc2UgaWYgKCFz
dHJjbXAocHJvcG5hbWUsICJTWVNSRUdfSURfQUE2NElTQVIxX0VMMV9HUEkiKSkgew0KPiArICAg
ICAgICAvKiBRQVJNQTUgZ2VuZXJpYyBjb2RlIGF1dGhlbnRpZmljYXRpb24gKi8NCj4gKyAgICAg
ICAgZXJyb3Jfc2V0ZyhlcnJwLCAiJXMgaXMgbm93IGV4cG9zZWQgYnV0IHFlbXUgaXMgbm90IHJl
YWR5IHRvIHN1cHBvcnQgaXQiLA0KPiArICAgICAgICAgICAgICAgICAgIHByb3BuYW1lKTsNCj4g
KyAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiArICAgIC8qIFBNVSAqLw0KPiArICAgIH0gZWxzZSBp
ZiAoIXN0cmNtcChwcm9wbmFtZSwgIlNZU1JFR19JRF9BQTY0REZSMF9FTDFfUE1VVmVyIikpIHsN
Cj4gKyAgICAgICAgaWYgKGNwdS0+aGFzX3BtdSAmJiB2YWx1ZSA9PSAwKSB7DQo+ICsgICAgICAg
ICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyAwIHdoZXJlYXMgcG11IGlzIHNldCIsIHByb3Bu
YW1lKTsNCj4gKyAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICAgICAgfSBlbHNlIGlm
ICghY3B1LT5oYXNfcG11ICYmIHZhbHVlKSB7DQo+ICsgICAgICAgICAgICBlcnJvcl9zZXRnKGVy
cnAsICIlcyBpcyBub24gbnVsbCB3aGVyZWFzIHBtdSBpcyB1bnNldCIsIHByb3BuYW1lKTsNCj4g
KyAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICAgICAgfQ0KPiArICAgIC8qIGFhcmNo
NjQgZmFsc2UgKi8NCj4gKyAgICB9IGVsc2UgaWYgKCFhcm1fZmVhdHVyZSgmY3B1LT5lbnYsIEFS
TV9GRUFUVVJFX0FBUkNINjQpKSB7DQo+ICsgICAgICAgIGlmICgoIXN0cmNtcChwcm9wbmFtZSwg
IlNZU1JFR19JRF9BQTY0UEZSMF9FTDFfRUwwIikgfHwNCj4gKyAgICAgICAgICAgICAhc3RyY21w
KHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9FTDEiKSB8fA0KPiArICAgICAgICAg
ICAgICFzdHJjbXAocHJvcG5hbWUsICJTWVNSRUdfSURfQUE2NFBGUjBfRUwxX0VMMiIpKSAmJiB2
YWx1ZSA8IDIpDQo+ICsgICAgICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyA8IDIgd2hp
bGUgYWFyY2g2NCBpcyBzZXQgdG8gb2ZmIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcHJv
cG5hbWUpOw0KPiArICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiArICAgIH0NCj4gKyAgICBy
ZXR1cm4gdHJ1ZTsNCj4gK30NCj4gKw0KPiAjZGVmaW5lIE1BS0VfSURSRUdfS0VZKHJlZ19pZHgs
IGZpZWxkX3NoaWZ0KSBcDQo+ICAgICAoKCh1aW50NjRfdCkocmVnX2lkeCkgPDwgOCkgfCAoKHVp
bnQ2NF90KShmaWVsZF9zaGlmdCkgJiAweEZGKSkNCj4gDQo+IEBAIC0yMjQxLDYgKzIzNDIsMTAg
QEAgc3RhdGljIGludCBrdm1fYXJtX2FwcGx5X3N5c3JlZ19wcm9wcyhBUk1DUFUgKmNwdSwgRXJy
b3IgKiplcnJwKQ0KPiAgICAgICAgIHVpbnQ2NF90IG9sZGZ2Ow0KPiAgICAgICAgIGludCByZXQ7
DQo+IA0KPiArICAgICAgICBpZiAoIWt2bV9hcm1fdmNwdV92YWxpZGF0ZV9zeXNyZWcoY3B1LCBm
aWVsZCwgdmFsdWUsIGVycnApKSB7DQo+ICsgICAgICAgICAgICByZXR1cm4gLTE7DQo+ICsgICAg
ICAgIH0NCj4gKw0KPiAgICAgICAgIG1hc2sgPSBNQUtFXzY0QklUX01BU0sobG93ZXIsIGxlbmd0
aCk7DQo+ICAgICAgICAgdmFsdWUgPSB2YWx1ZSA8PCBsb3dlcjsNCj4gDQo+IC0tIA0KPiAyLjUz
LjANCj4gDQoNCg==
