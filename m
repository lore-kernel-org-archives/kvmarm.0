Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9004E352C54
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 06:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785912517; cv=fail; b=qQMldR8Mi5LQW4hbpBm0rXr/D7b/HrwXTMIrmf4WE+n6xPKjZK4RwZqknKKIQCXdFZLFquNT9C/Hx7+LEVwtmPUoiiU0TqOJO6gNGoIaNnf4u3uLL5zzH7D7zkIqTvG0aeCNqWZv/yDuOVeXo3kWj/bF5XhgBD+UY6BjD1/7Pdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785912517; c=relaxed/simple;
	bh=ahv8uipQ1tlSnW3VYBPmemDWKSye49BScAqnrCxPPYA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qx1HpU+4fU6QSXd6IVRnHu74ZLihJnttw2dqSenrcAaexzjNAdH4KLO72Sx7H2EGe3Xf10dffy/GfAUVw9vE/3alj0EmAmhyr+GBUSRuN+B3CL/h4noVN4iD7pGcOBxr5dYxR3Zwx1kPksRmq2ctAUrlq3+L7x0FqOjt+8l+QPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=UW/Lyz/N; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=zBrsnj/Y; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="UW/Lyz/N";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="zBrsnj/Y"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755lodf2623765;
	Tue, 4 Aug 2026 23:48:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ahv8uipQ1tlSnW3VYBPmemDWKSye49BScAqnrCxPP
	YA=; b=UW/Lyz/NWmuXBgspeyQlxAHY8P+vOtgVYBitD4Jv/Jx1TpyYgBLXy69Ys
	jpb/Yvg4XymWm91nHwDDehIuUZPqYtK8ndvVWuEsKk76VTxaCpUHNjJ2T8Bpvzr3
	6WnMKzy0zqjjujZRalYJgDbCCAqzbdZ7FOKrKqJ9bBnL/S4/Nph9JxpApULjcMIJ
	AlqBQV+QKR8oWGkfH4/fwe75IpakP7x+eRj/UmIAurhhO/y7zxLdoExxzO/1CiSc
	8jBogRtWkwjJBIrqqoOhtyDLthy3C+Uv8iOvuuvBZHAvgt0WWz68ZmTQN4R0hqc8
	gyFtVT7M1V219R/xrgTJxY0E0hbzw==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022098.outbound.protection.outlook.com [52.101.48.98])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fuhfwt0rr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 23:48:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mJEQJAa9Ps0wVx097tINWE4QZ5qnpX50KHsV7xJW5hDjn8sONsLzn5aF6OgQ0pT7R55K+hp8F/BMe9P7xahIM+T/OtfRZ+yjjSJqKadyxgvMDLtMCH0R0pVoPGM+uccmfO8FkuntNnguS8VnlJTv4ReY7CHckhX2w63DzRwG/Tneo+vyndnMo3Uv90mAW+kHtY5RozE0ib9RXg1iOfFUQREWU9tJD+vy7xKvdcrLIP1pCsflQhK6m+ghqKQda4zQGlQJ8egQH9WxwYxKHkME+ArwSxT2OrNuESO3hljC1xdjgtlgisXw7pHaT5tp/ZIUZHs67zgEFWsN5ilK++4qPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahv8uipQ1tlSnW3VYBPmemDWKSye49BScAqnrCxPPYA=;
 b=GAcTdhxV9pV6d72yL8g7TE54MKeO1+NxEsRCRjloKgH323BQS83/FV+T9oInPo5rl3a0BduNryhvKtLmtWVdTGRyShGgScMlBEXDiHOkDZfHr7LRjPtZAh3DTAQKL06MAO2kI8iluecN7nXsSLsZya3Jk6v54W0wwNTTyq7GnHxvyBqHAz9jNzUQqVVXlFb8a3uhrWKzHlqZ+6bLvPDN88w7vijakbucRSupfM2QPoKwEo0BCf/oPpnrE3eFVwuQfrZqn0BKewqg64Ys3sXr/p8hzkgR04MwY7YTDmQ22sOrn2VDHjxZBKqMOE+eD7AANmNkFqY75MOk8cPDAeW3rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahv8uipQ1tlSnW3VYBPmemDWKSye49BScAqnrCxPPYA=;
 b=zBrsnj/YxZowxko9o5IxHDSXG/HbDMs4rJJkWs5jl62+uqnkJSSsgCMc9rm4digxjLFSWRnHmBHpPwo+MxLkLXqTudUAw9z2uNzw7HtVAWsNOZZk412n7+VcVXSiMvDyGnKuSpqxPfJfJ2uOYpfYq/kZF3vSsQvw/BDf+9Sy1ig8cUTGYpioyTnJ1FfFewI4SKhEEu/dfFNapJLD/WP8FnVUOmX1jo+RJnxapaXJueEBfJkj2xk0Rbiew1PbfUTe+nPAakddrmHoawX0ldbkYAv74AvnWwe+sg4PHhTIbnxDaH6BONLUWOcWtwx3afIYgKxycyMe2FBGv0txqRLNeA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY1PR02MB10380.namprd02.prod.outlook.com (2603:10b6:a03:5aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.20; Wed, 5 Aug
 2026 06:48:20 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0292.013; Wed, 5 Aug 2026
 06:48:20 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Markus Armbruster <armbru@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com"
	<jdenemar@redhat.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com"
	<sebott@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Topic: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Index:
 AQHdFWubvCZ5bHZqSUmcDdL6/mUClLZ2aouzgBYuboCAAOqvpYAAAIwAgAAGWgCAAAYJPIABkVKA
Date: Wed, 5 Aug 2026 06:48:20 +0000
Message-ID: <08DA9B28-D5BD-4EC3-8182-FEE212F0C2A0@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <87y0f5u78t.fsf@pond.sub.org>
 <6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
 <87tspa5skn.fsf@pond.sub.org>
 <FD805FA0-9323-450C-9D79-319C0883F05E@nutanix.com>
 <FDD5760F-94E6-46F4-AC62-AB0DC98322FD@nutanix.com>
 <8733wu5qfs.fsf@pond.sub.org>
In-Reply-To: <8733wu5qfs.fsf@pond.sub.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BY1PR02MB10380:EE_
x-ms-office365-filtering-correlation-id: 26ed12cb-4c30-437d-4527-08def2bd897c
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|38070700021|4143699003|56012099006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 1fDkLUDRnjL2qKQhV+6nCAAtT74hjYFndwVnXoHalaO/mZsCxdMgwZo0v05JT7TRmzodLEncOODYJy5htQkNkDT5GewlTaumYOaZw4NFKcHl9Tv+xeP+ciMIWqWC+AQOQkr/OM78K5QJkAluicjN7O8xsfm6OlaoT3FDPmbXcJqVuVFsNyOOihv/1ml5e5tdkdS5JndBzc+ahOwP6kakFjnGsEhQuXRfsvysp9YKbTNYYN3VDCpLQuF0xpGYehWp0twUsDrBwyt+mERHYHXl0rt4U+K8EcLrKy/o1i2kZvBrIgoPJY5yy5bwv6aj0MeJffPSBfVCb1g5+PomwTOtTEPEECqgli0O6CralBsxr13kHiLuhyKAAnXYzCrQ5TXWsjWPZtepeB2dq7tF4xnUsH7PNjm/1LHwShrnP6IwxbmBq0GSu/4gjZuLp+P96aMHmxhJEiboLg8pFDmnatfQh0DQ7CZdV9XXgyZSfs4ClEI5OmcO49jEFPhHyTmEJTBBCgrZQTHoarj0v/0O8QoKRJB4FLEzSJlNgBDAjTn0zRl+IvtsGSKWADCyuqJgzwM5sWC9P9MBmUCmznKj4ypI5cs1z1+naAFsQAZrxZ1doCX7phf1J7Dt0pqBM7NzATjNal9o6A+zM3ukZd1XVy422RcRrfNR/YQCW4u/YYzJNVfS4OARgRFPUuFBFMXY8kDowzrpzNAf8KzqnMo2+2vWPIXCLqJ3dqh27xkAojRPUBM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(38070700021)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZlQ0R1piWVRLbVcraXR5YnpLVUtDQkJCMk5kQVVZYWZQWWt1eWhpSmJia2E3?=
 =?utf-8?B?aVNQMkoxOW9SRmJveEZpcjd4YkdJNGI3d0dNeUFqTlkxMVZuUXpBd3ErZGlP?=
 =?utf-8?B?SkN6RVpzck1Eb1hCOVVEcm5MSkRRY1BhWEdrUnl2TndlanR0bHUyVHVEc1hE?=
 =?utf-8?B?M2ErL2JBejJKc2NZeW9HNStWK1JtYkpwNzJIOGVaRVZOdjZ4dHRycW1kd1F2?=
 =?utf-8?B?R0RDalR3STBWZDRjcUlZTldSSk02OFVMTnBKR1hVeVd0NHBDbnpLc2NQdG9Y?=
 =?utf-8?B?eXl4WkRSb3IweFpKdXFSeVYvM1dsQUNyeE55bkRtcngzN3AyLzgyaG51bk1S?=
 =?utf-8?B?U0tpaVVrOU9vNHB4bkdnSlFqWC9NSkNBcVdCRGNzTmp6aWhJNDRrRmVmRUo0?=
 =?utf-8?B?bmE3RUFuMmtVZDlGaXNyeGZKWEQzRTRVUHpScm5oUmlvRnlxTStOUGFCWVYr?=
 =?utf-8?B?NUJWZTlwWngvZ1NBMVpXTkRNU2NrSHhYc1ZBY1YxQkFGKzhmSDV5MXlmUjli?=
 =?utf-8?B?bndneGV4d2FNWWJZNGUvMEdlTk9tcklWL3FmV3dyNWpHWGpTanc5UnB0dHBu?=
 =?utf-8?B?OEp5QzZJby91QjNjbzBTMGdzSFNoNUNmY0J1M3R5MERTc3ZQMmtoSnBscmFK?=
 =?utf-8?B?SWJCb2I1RmVEajZVaE5vanNqVkY4VlJ4YjI5eFlvQlVuR2pxc0VBV2Y1MnN4?=
 =?utf-8?B?UzhuYVFWbWdVVWNLTDg3Si9JdnBBWnZPMFIyMlFsYjlQdkpTNWNSRE1vVmlj?=
 =?utf-8?B?REdXcFpPQ0d1bFVuZjVvMHhoRkQ0MEg2TmorM3FoZzg3bHUwdi8rV01RbmRP?=
 =?utf-8?B?K3pBd0JKeGxFQVBwUEd1OUJjb3pPNm81YXYyamtuWXdsRzdIY3JHeFhPOFMz?=
 =?utf-8?B?ejJzVC9jV1lZMy9MZ1dBWS94R1BKZ0xjc2s3ZzFQOFBlWW9kcmtwNG9yUXhu?=
 =?utf-8?B?SWdlY3RKWnMveC96VUp6RFdBbUxiV0lvWGZVUmFkbnp1dHZQL1VaMVR5Zy9L?=
 =?utf-8?B?b085U3pnRVBCdTFKZFhuY2RIZWVkY1VkUUpBRTFBY3FzNVRZSTJMakp3M3VY?=
 =?utf-8?B?Sy9NL2JFRVJCbCtlMkRDaUhCZVcxc0pHTjkrVGYvVndLSzN3ZjNIMi9HbGU1?=
 =?utf-8?B?bnMzQWc4WVBicjJsSVYrODRCQk8rWjVjTERCR1ZTcnE5WXp5TVExV1hGTkxX?=
 =?utf-8?B?cEJvcGcrbEY3TG1CTnBQczBzeDdlR1J0STB3aE5tNmlyTVIzUWNQWHpkMWhi?=
 =?utf-8?B?ZnY4NWR3bGkxb0E1ZklBUWNtdE0yRjNXL3FXUVZVcDRKQVE2M1duZUtTeHJW?=
 =?utf-8?B?cDNkb3paai82a3lpNUZDK3h2YnR2Q25mNjh0WkZtUElqNkQ1UVBpNkVMS2xu?=
 =?utf-8?B?TndzZGZoTnJVWnkzWW1FOG55RUxQZ2VrdHBNQWdrcWVLS3U1cmxnOXJvWk14?=
 =?utf-8?B?ck5EUVg2d0lMa1BQbUtxZE5VelM3dnYzS3FXYTBoRUNMRTdSSjYrUHJrRm10?=
 =?utf-8?B?UEI1THdhMGxvSzRyWnMxZ1drQVROLzF6czlkOExHYXRsZnJpUnJ0L3NPWk0v?=
 =?utf-8?B?VGN2N3FTajlLMXBRaEIrSnYvQ3J5cVZ6UCt5bEpDQWRacytnYjN6cHV3WFhN?=
 =?utf-8?B?QkRMeHFQUnRvcHA0OXFwdnZUbnlUdnhQNkpDeG5iRmowRHJCWGhGY25PY3pt?=
 =?utf-8?B?Sk9XT3ZXcU5lSWk3WHdxQVZaeTJoUEJHK0FMWWt5dVZzRit1YnFaeHJTOEE5?=
 =?utf-8?B?dng5eFNkZytvTmUwTGQxb3YxNW95bHNwbkV6dUpvRkw5aVNJYVRicU5XdTVW?=
 =?utf-8?B?R2VSMWd2c29BZjFWMjNkaXBycG80MXlMMklKSU5YVUMxTzZzbWViakl0RHBn?=
 =?utf-8?B?dEVPajJSZkhGbnBiUUhTMnZRUjQ2T1pMR3cwbXNTZlR5MjdNNkU2c3dSdlNw?=
 =?utf-8?B?NFJEZTZxT3JuNUpNT2J5WjI5Y3Zvck14T2VGL0FmYnNkNm9vRnVKdW44dFl3?=
 =?utf-8?B?bG5zVTFYOVVWZGJOcXE4UmM4a0hKVFNRb2dhL1FId1RoaDRYWFMyT3ljeTR1?=
 =?utf-8?B?U3YycXlaS3FyaEJzdzBVYVdGNXBlT3VLSXk2TWgxMWVQVkpPZjhha0k5ZUl1?=
 =?utf-8?B?RW1ld0hMTytock9aUlExK0F1VEJUVGdTZFNISUlFbitLM0VOMkdsTE5raVNV?=
 =?utf-8?B?OXRRWUhxcjJ1U1VWME12NzdHRzVoYWhmcE93c1VMRHFuY2tJZjhsak1VZ0Qr?=
 =?utf-8?B?b3plU1UzVnNvZ0RrdGpXYTBQT3E5MDZpbTRCRU1nYmJ3VmVkQVMxWFRNU3Bn?=
 =?utf-8?B?WTIwWGNZNkttQ3hFdmh0Z3dXTldSRjkyNENkQ3FlcFIzQjdjNmlKL3h1cGJG?=
 =?utf-8?Q?OUzBxT05NjKL8VwA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9721168F9D03634EA223AB18DE4BA04E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	SvIPNwQcYnd3xldoIN5BIwxWGwX1qBB0RfyE39Tu7KscSkfoZX0qGwOpt8X6pY6exBa8Ah0C6ve8F3wD3GV64NV5EpZ5icYBuwepIHDjsLQGgiH+6Ik8bBSVmy4PLw83zhS2oQybhkuJr75HW+9gJOrOWpmkveStxyM3xA8tiEfHGcygtb8ZABFnk6p5hItdJt5bmwC2D3q5/djwpgJ9tR/XGzyjenmS1xPl80XIQV10HH1f95/XO8OxUTGbHMQtCLjH4ShhR+5EQvLKWcN6G6IwEdPRppHFhJmOiQzlJb/IDjeR3wvSat6tzdebBsRL8QKQSZKrCqXCXrzKaHnVGQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ed12cb-4c30-437d-4527-08def2bd897c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 06:48:20.2107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2IGTvGR8w16rBsXmArr+SGXRE1l17a2lceOmczZoI1O/6bpUyF3+IBFyRoCDeeW2pDk8gAc5Q6VISf/rq88juy3s6jeTihPV/m224JGHP+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR02MB10380
X-Proofpoint-GUID: VCJGvZimi25e0fgE2ASgZUC6z16kB0VJ
X-Proofpoint-ORIG-GUID: VCJGvZimi25e0fgE2ASgZUC6z16kB0VJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA1MSBTYWx0ZWRfX+TLMl68/OTx/
 vZ3DQ1MMfne3QNxltvTJWgtXc7fd+6QedFHlbRxCRPI8/9jxGJPEiEXB33kVUV/D6hwLc8zTt82
 kX9weSSON+y4eee7yC/iCqqRXajjiUPF2Wo12ZNyJ9ecIm/IqH8yR7U5cxpkDT6yd09XoB2EAoe
 bFMFUNMO1xxZgJh8REGGguT7YUNBV2GC225Lxp61lNCij6nuKuhv3Xj34ZR89T0+zAN+3XkFy75
 HbtiTOiGP7D+Zuv29ji3jdruBTTTYY/LZByacARskCVh5XB4iTFrdVeEkY0hRodojZBn3GJfmrS
 sqLL1Yk7DyoAVf1IE+0Z8M9a1CgOojO36R/xxtYZokab8pPFef6n326Mz+SsPcS/5zptX39ZprB
 UIYSFzC5MtKousoPkF8h1/9jLB/tRUCFftdE22p1YGHXg/tpZjNx+jn6XMsY0G9y8ICnzhfdUpI
 4PG2qAtfGISmtYrIC+w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA1MSBTYWx0ZWRfX6Y7qqCTXBSfj
 sdx6Dkawg9bS4l85l3BrdgW+xJ8QQL4TQc3CCKP5E4M4nnzmrO+tRVEdjSZ99kgVOXsEiHomQio
 setIGbf5YgjTboUbb76gZ0YLARTjl1g=
X-Authority-Analysis: v=2.4 cv=MbxcfZ/f c=1 sm=1 tr=0 ts=6a72dcb6 cx=c_pps
 a=JnPQUT+nmGgr9A6OKrSlWA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=4rDnuHVfvjYYLniGX-oA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gNCBBdWcgMjAyNiwgYXQgMTI6MjHigK9QTSwgTWFya3VzIEFybWJydXN0ZXIgPGFy
bWJydUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gS2h1c2hpdCBTaGFoIDxr
aHVzaGl0LnNoYWhAbnV0YW5peC5jb20+IHdyaXRlczoNCj4gDQo+IFsuLi5dDQo+IA0KPj4gU3R1
YiBmaWxlIHdhcyBtaXNzaW5nIG9uIGFybSB1c2VyIGJ1aWxkcy4gDQo+PiANCj4+IEkgaGF2ZSBm
aXhlZCB0aGlzIG9uIHRoZSBwcml2YXRlIGJyYW5jaCBpZiB5b3Ugd2FudCB0byB0YWtlIGEgbG9v
ay4NCj4gDQo+IEknbSB3aWxsaW5nIHRvIHB1bGwgYW4gdXBkYXRlIHRvIHYzLCBhc3N1bWluZyBp
dCdzIGEgc21hbGwgZml4Lg0KDQpJdCBpcyBhIHNtYWxsIGZpeCA6KQ0KDQo+PiBJIGFsc28gdW5k
ZXJzdGFuZCBpZiB5b3Ugd2FudCB0byB3YWl0IGZvciBwcm9wZXIgdjQgd2l0aCB0aGUgZml4Lg0K
PiANCj4gRXZlbnR1YWxseS4NCj4gDQo+PiBBZ2Fpbiwgc29ycnkgZm9yIHRoaXMsIHNob3VsZCBo
YXZlIGNoZWNrZWQgYWxsIGNvbmZpZ3MgYmVmb3JlDQo+PiBzZW5kaW5nIHRoZSBwYXRjaC4NCj4g
DQo+IE1pc3Rha2VzIGhhcHBlbiwgYW5kIHRoZW4gd2UgbGVhcm4gZnJvbSB0aGVtIDopDQo+IA0K
OiApIA0KDQo+IFsuLi5dDQo+IA0KDQo=
