Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449103EE1E5
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 09:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008278; cv=fail; b=U0u1YqcRos1QlC4wVSx7XiRbXku7yBHYuDoBuz6E/4MQg1Zl6gcXKiRYS61Oj4qUyPVoE21wfNiukc6WVxDknq6c8pY9e0hAE89/6oZUzR7BRH1M8eW/dMl0PyVuCB5Ux/+bATDHO9Q3hVuIjvNUEkp07lOeFSmhQlKu7cm3/7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008278; c=relaxed/simple;
	bh=r0LDsINqxVUzvG8hoM2ca2N1ZJi8JZqktsRIuejXk9Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aq9OoTAzt1zb/SVj/hwMtkizfzc+de2Lji+c+SaIeVuWKKTOTHkHFWzhk6xoKp/x8uWdwf0QvNP3um7bpPQLhhJ7mt0AkQ3dJXfM0088BSxsWUgA6NqqPdLpaDaSlvdD4Jc+P1F5JOVe+uKuxtPTLyxH3lj1ZHMIgEsvoFrPW+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FUouBDRu; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vxGn4BLB; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FUouBDRu";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vxGn4BLB"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NYR9C881428;
	Thu, 6 Aug 2026 02:24:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=r0LDsINqxVUzvG8hoM2ca2N1ZJi8JZqktsRIuejXk
	9Y=; b=FUouBDRuoJKxL19lYqiKnWfToRKN//gOgbrzC3Y9u01lXUvAUN2M44hNP
	2UemBHVg7y2+qHzzXZxyi55T5IN83OlMZdgsVX5GtfqrNDrQepwDfZEdA95Kwco2
	aC8bdOFjTZcBW2qwTTCzyMX2OjvlzDWgvlf1VhzcrwQ8XOnO6It/g0RQ59d4kvIx
	ZkzrshuWXK8C3cl2S83uK5nn8nRhgrl9eLSw6pkp7AjHQTGJVB+dg/xvS8+baYHY
	pQNR+3hcqxWfz78zweAOK3cKxvFhfBDt9FHw9lfhjwmRX38EK+CHGZIdIvFq3oil
	SqdT4KiLtILVewp7+HyN3uTQGMVdA==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020085.outbound.protection.outlook.com [52.101.201.85])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fuhfcdrm0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 02:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FsufvNX+ribItqr+cfyJJQ7Qqyb6BD+ty77u62U8U/EtbYYB6q5bW9sI+U2EXQdUGLkspmiSr17B2CYUbFF3F2gOFMmg88DoRfTfX4x96FTs5XLosx+Yr4C6ll/iOg4pTXH5goKq0pb/TFDm8ApZLuP3DC9/4uC2Vte7KQQDcd5z9n1LSp/H1MkIOaXFNQ6Liif6VCTePFmEyU20FWczDXoYqgTxIUwCaEVGzI+QzNX4oVFfSJY5XRrgxZHYPmKUp7hmfzjnp/E5QVRFtgQ4mOoHsO7GNERVyo+ixT18XLiTPnNkVbFqN9GDx8KE1RaSnBFKl27AsqimVqRkQpU5wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0LDsINqxVUzvG8hoM2ca2N1ZJi8JZqktsRIuejXk9Y=;
 b=ie5kBkg1R5xJz3YNpq88S4wuIvY0EZneZSu8StQy71AvLLA9JFG+ErYoMNYdMmc2F1X8Et22P/hd292mGPWRMRimp/0YPO3E4Yg5JCQCwlcGG2hlaUu+u+R20qSQJvjCpB8jDFngSRQ6dzJKkVPm8KZlNogBIljsnow8pV7gsTujvA0gM18WdK1xXicq3+fQ4JuugB+CA8lW2emPyxf8QGIeJpo9C5zG1jcC/7WYbI6+F3s/hh+k68aC1zQY3IWSWdp+OrLE3mByzlSUE6Wzqhdnt5JRMJVgXcOYCkrDLIeQ5wYhuH6LtUZ30f9Ne2WMxJE5+6Vp47yoMCQxzICTEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0LDsINqxVUzvG8hoM2ca2N1ZJi8JZqktsRIuejXk9Y=;
 b=vxGn4BLBksW2VsYbOvjQSJFnKMk0fDo9LglHwMwr8FYaBH//H2Z5S5RToooPNjbFDdk5xnqrpJW8SPFCbmyDa2rGHAP359sviBrPrjDwiMNaXc5DII02giatKeXGrjSYpCZ0Keuo/H3E/Rsi+VNie2XRY8KHQ2NFZ10n7RBTnsg4VH67GWJnK2XaPOCfhF8lsTzSZePWIxk7AZx+OF0mRFaNTwzkRuyTAgj1wlRoodNz2PFmHk6lfdhHAJD3PghPWgZGPnXPJkxNqiNxQrCvkJZCEPTkEliE5qiQkl3AAIkFSSIgpwNK7R+UuoLf6EPhyM+9QvzHidv9zvpondmuSQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by MW4PR02MB7411.namprd02.prod.outlook.com (2603:10b6:303:7c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 09:24:05 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 09:24:04 +0000
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
 AQHdFWubvCZ5bHZqSUmcDdL6/mUClLZ2aouzgBYuboCAAOqvpYAAAIwAgAAGWgCAAAYJPIABkVKAgAAC3zqAAAlggIAAYgwsgAFPjYA=
Date: Thu, 6 Aug 2026 09:24:04 +0000
Message-ID: <7B2898F0-DA7A-4DFD-A2CB-997833A47A05@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <87y0f5u78t.fsf@pond.sub.org>
 <6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
 <87tspa5skn.fsf@pond.sub.org>
 <FD805FA0-9323-450C-9D79-319C0883F05E@nutanix.com>
 <FDD5760F-94E6-46F4-AC62-AB0DC98322FD@nutanix.com>
 <8733wu5qfs.fsf@pond.sub.org>
 <08DA9B28-D5BD-4EC3-8182-FEE212F0C2A0@nutanix.com>
 <871pcd12bf.fsf@pond.sub.org>
 <5F6481F1-B5E1-4B30-A4D1-481D9C0731AC@nutanix.com>
 <87o6fgzopu.fsf@pond.sub.org>
In-Reply-To: <87o6fgzopu.fsf@pond.sub.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|MW4PR02MB7411:EE_
x-ms-office365-filtering-correlation-id: 0da33184-29d8-484d-1a25-08def39c755c
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|13003099007|18002099003|22082099003|38070700021|4133799003|4143699003|10067099003|56012099006;
x-microsoft-antispam-message-info:
 weT7jwdsJf96dgu440mbBIj6S0DffwY85xOXJfHNfiQYdRCaSrz3kLS5DRpmBPdgPLKMxScQiHeebZrBAwQf04K7sGYDzwLwR0lfroaoVGo9NK0U/eP2QGOL6uDfO2Cyw6OkABeRaVssUN7GXOMZrJRp1H3wMWdRGIoJ2vsNmShw4Yv2ksz6j+TjlnNiW/PKQBf3h5AFxxRHoh2EjeyJoLK93L/haYI71tIawb5VUfl/QOMzFI5RThxNGLscO9Hm+BF5Lh3NGMTWbZZm1kEv6K11T1N0xDzDBZPBxrp76thLwtJFhFa9J2p6niAmjJeR65JTBVqoyjz93RSXOCXBOs96Uy9onwbdIcum90vz5G9GGJVWX4kn1420AfDHcTo9CP1vxDidafbZowF8pYnmd6bPlNI3tjjqFY4ekeDcsA1z2CaOPiInIq9/+t5WzgzXqwlMHBtj5q7CvGQzET3OdLGeXZZ3bk6cnPeQk2wzpFiqH90uW7NzNqEEyLs0SYFmy9fIy12ajc7+vK7yBbInMADTPcNRhYxKPApMp9LdEoXbUGRpQDbmFx5Dv0WuxWuIWejgBUxrrA+bRk/KMKgNGeY/noh41nvrT7+qikCW/owtUFTAZOsiU88EAaiy7KGIrYgTQipCIsR1XXXziKjmRWgRj0FKeQ3HluJVFX1fXFXV5YKSK/mJXSZurGu3KhC/P1vMwNpIDJyFk1B6UhS9alrQTBZXiSY0kAyvmnAaIjQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(13003099007)(18002099003)(22082099003)(38070700021)(4133799003)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZDlSdktGaVAvVjU4OHQwZGl2VHlQd2JhRnl5NXViV2I1Sk41UXdpOW1RVjBM?=
 =?utf-8?B?b3BnOEZiZjJUalQwa0R5TXdXb1NGckwvUGhTemw1bFJzaFg1WVFxTWNYY1Vz?=
 =?utf-8?B?UmppQVBIdHUxR0JlTXl4cUNGWVZFSUFJLzllbTh2aVYwZ08zb3h2NnUvYld4?=
 =?utf-8?B?VmhxYWRndnRXVkxTYkI2dlZicHlDZXRrV1B5Vnd0NnE4aVZRU0FmRUlQbkJC?=
 =?utf-8?B?dEV3L2R2UHhnQ09ZekhDQUp0Zm5rY0FyZzZrV2RsTU1NSnE1UXdzUDV5bFN2?=
 =?utf-8?B?Z3FtVHc1eDBvRjJ1c04rQmVPeEx3bTZ3MjBJb280R3NobGpRaXV0blhLVWN0?=
 =?utf-8?B?aUdMdlR3Q2x6YVR0M0RvZmtQTUw5SlB3KzYydmpYWWNHQ2VNVEh5U1pjN0Zz?=
 =?utf-8?B?UlhQM0NFVi84akZHQTBmTFZpRTVkU3dMWFl5Z1o5TmNJeUt1OERudU1MeW1O?=
 =?utf-8?B?bGtjaVpEeUhncWZabEl3djhST1hDYUpPY0tLY2RLSGdoZkg5SzVtK2RyVm5Z?=
 =?utf-8?B?NnU1YmRrT1RzaS95R2VEU0dTMkhSSjNJMjVOUXhGUktCSTV5SjI3L2prb3lw?=
 =?utf-8?B?M1g0U1VQU1grTHlkRUxxV0VhNkd4Ri84a2VOUFlKcHZGYnYzTFlDUUZmNXFl?=
 =?utf-8?B?VGFIZFNKYzVmWXcrUUxsUUdvcThkLzVKQUVLaHBvVllNcDFHai9YSVloaURN?=
 =?utf-8?B?QlRtYjdqTml1SUUzT29TUXkyTXRiRjFFdDhnVkxOUndvemllNjNGUjYvUWRO?=
 =?utf-8?B?amRiR3hjc3NhTXdHb2V3M2syYUxrUHJrQWxVTGJ3MUc1ZVU1VXQ3WEVIRjFK?=
 =?utf-8?B?ZGJuWE10U1BLN0RCU3lmZTg2UTVsclp4QWp2K09JUXNrTU51Z0gvbXhqZEd0?=
 =?utf-8?B?anJnYm1ZaTFYSDJUOW0zZWNwMlpEWkg2cmVVbXp0RE1YK05OK0xORjRRY05M?=
 =?utf-8?B?U0Z5VFUzaTNWeTZoT3BSYnVzUm54aHFmSmd1K3lOZmJDeGJHczYrRGxiV1JL?=
 =?utf-8?B?Y1RyTkZPWFpUaWdUd0h6VHY2ODFtUGxSSXE3UkE5STI2cDNWTC9ETGRZb2R6?=
 =?utf-8?B?K1RhNEplQ0lnVktjRitZSm96SWtDNThPcm44MnZLR2dqNXNxczRQQ3QxY3Ns?=
 =?utf-8?B?K082azlkRWdXSXJ3TmRZaUdqZlpKYjBSRXA5UlhYTjl4bzh2SnRjUFJzZm56?=
 =?utf-8?B?VjlEY3J5bkJsaFJQWU5ZZTZNMjdac2phTmVSNjRER283MUpGdHorbVQ5Q2RJ?=
 =?utf-8?B?VHp5WnRmVGI3Y1hqSXExWGVETE40ajZOMGFRWFRnVkRSd2RCampiQzQyRkVv?=
 =?utf-8?B?TXBmVjhuNnp4b1h0d1o3YUVLRVVXVlBNeDl6clNqNmJJN3pmb3oxam83RkNX?=
 =?utf-8?B?SEVYRFo3Sm96ZGZZcTNPVHZKVzd2SEVEUXoxRDFXcFJBMXA3V25VL2ZYencv?=
 =?utf-8?B?ZkpOSWp2WVRQUzdFdXNULzE1ekRWcXZ6eGtxOU5xd1JCa3BSK2pzUUl5THh2?=
 =?utf-8?B?ZXBZZlVzZjE5QmxTRlFyMnhqMWwyQmI5dlU0MWVSaENVSHVCcThVcWl2S2FU?=
 =?utf-8?B?b1Mvd1AxUHVOcW9pOVY2VnFxL1VDTWNuV01qOE9ja1RUckprNmNTRUx2a3dL?=
 =?utf-8?B?YndVMUthbHlPZTBWNHM0ZVdiS1pxL21tWHc1QWUzYXUwamV6SVhaa1diQmlX?=
 =?utf-8?B?L2lDMGtaUi9DS1FBT0NQaUtKTU51clZPVUJMQm5rb0lib0s4U0dqT0h0cnhY?=
 =?utf-8?B?dXoyZDlLVnJsN2M3K1FyaVhSTUVkb3Z1TTBHYTlyeko0U3NFY1dsVitNdXNV?=
 =?utf-8?B?R21wRmtmOG5Sbzd4VmJGTnAzMEovOUhuZzduQVRNQzhyTXI0VUNOdnJTTXJY?=
 =?utf-8?B?WWw3OG1CZ3FIMzdGMjltVStEalpyNU16UGY3UUsrVEZnd0tDOEpuZ3E1WEVK?=
 =?utf-8?B?T2hGcVdIUEFFMDRaUzRQTEhkb00rVGZCbXkwR0tFRElHVjl1MmJLMnIxd2tT?=
 =?utf-8?B?TUtkU2lma1hrR1dyeEU2ZVcxU1Fvck1GZDhoWjBXUjhUL0l1VCtBWG04NnA4?=
 =?utf-8?B?U1g2Z1Z4WVJVK1NuaGRsSEpyZUJoM3R4VmxaVDFGL1pjL1ZzdWxOVittc1F4?=
 =?utf-8?B?S3Z6RVl3LzZkdzh5dDA3OWpUQ01YOXRzckFaZmZldFo2K0hKb1ZnU1N0OWRU?=
 =?utf-8?B?RjJZUVNiTFYycE9aek9CT1lZUEM2c2YyTkJPYnFwaWJ6MXR1RDl0cHo2dzY4?=
 =?utf-8?B?YW1hREhadHlETjFBL3lGZFE3dE1LYXU5RmRGcEFQOFRaSDA2V1djN3VJS0o0?=
 =?utf-8?B?N0VvNHRIaTR5LzNhS2JvSmF5NHYzWk9NQ3c4WndGTGtKODFHbFp3UTJpRlhw?=
 =?utf-8?Q?g5+HGGsnbi3hGiXA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <865BCDE36F912840A87367E5954D93FA@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	dnjkiv4VY2fppAFTddLZK627D3TZ1vFPyOL8tnJxSyBY8X9sXERYupkuOQre5x0B6Wojiw4aZTcs9SJVKOUj5GEoSsTTCk4Aln351bFD1YIVqIdMGxsax4PmsGl0N1nfubAtdxcT3Ey6l7ig6zoyKZ8Pv21EPo0HMdsia8KqOwewEtCs+9rAS1iqFYhYsBUMzzDAQznnMxs0vQA2jqe1VTY1H2Iq2wabn9YzfB4E0R4naPvH80lqrk0ATLP/BqgiylMw6XQvYTtaePmPpE+5yTyzkfdCqZ4/bVWckWn1siLPhnIsnZ0WnjmIIOkk5/vnh+qNpiC1NA//T5LL62Fmpg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da33184-29d8-484d-1a25-08def39c755c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2026 09:24:04.1983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n4O6r0jPJLtu5S9QGiz1LjYYNlfajNjMgSbdhMcLOVll4Sn5ejllHNp9r10uehmxUZezFTr0pcPRpqbToXOLazGKqUjWjuL93jx8zf7pi+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7411
X-Authority-Analysis: v=2.4 cv=JN0LdcKb c=1 sm=1 tr=0 ts=6a7452b7 cx=c_pps
 a=H3Na7JgWheL2EZIWx/c7UQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=NEAV23lmAAAA:8
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=A-3yAG_m9RM1Aa1Ao-wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: QyGT7C8LfhhoLu97aszLBLXejHZ1U0iB
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3MyBTYWx0ZWRfX9cZKakyVXmw3
 a5XextUfenMSdeQYjoTrDeoxd46QUu+B12nkpODl0LFXb7qkiMU5s/LNSGrcvQMEBj8Jv/5n3XH
 gTZ3GQIAJbDLSA+jGD82HdmGkbz503E=
X-Proofpoint-GUID: QyGT7C8LfhhoLu97aszLBLXejHZ1U0iB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3MyBTYWx0ZWRfX+DdWXc1BoKv3
 hmlsCNh8YkaO3rBD4CByZT7jAySmoVxoQ2+yX5LtcR1cjkuMUX8R6u3bhXqtIwZ5axGHKxL0dR/
 w1HTC0tH3MIVsrtrmvgjnQ2B2vIQOnRBFmRvvIabHAVAOzALkr9JCkC/6hHPK+5OO/+PDZ/enIq
 8B/STMgg73zP17C2ErlTBil1DedEMarRugLVT3blVd80nCQPNUqQ+dhLmdKfGvao4EYEEMroLdW
 Nv47Jy+EdqW4U73TcNHQ6fnVnZssm6DdRFDk9uP5MaE0Iftoh2ZXhVkh5UbfB0+WDtP4AhoGVxb
 xmx9NHS419ENBnmi/c5/czkhrXN8MVAoFbv13JNxLSkT5yxEnt9ZfOSwQSaXKtUD9yaHBNyhvMi
 sneSv3cjYBHSsywJfmJJTfUJ9Pm2FWEwhQAfZZkiLialLRwtflVEIiOSwfQGmj8iTgcalOcbkCc
 bo5iDZ2ICDzRSG/rPNA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gNSBBdWcgMjAyNiwgYXQgNjo1MuKAr1BNLCBNYXJrdXMgQXJtYnJ1c3RlciA8YXJt
YnJ1QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBF
eHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBLaHVzaGl0IFNoYWggPGto
dXNoaXQuc2hhaEBudXRhbml4LmNvbT4gd3JpdGVzOg0KPiANCj4+PiBPbiA1IEF1ZyAyMDI2LCBh
dCAxMjoyOOKAr1BNLCBNYXJrdXMgQXJtYnJ1c3RlciA8YXJtYnJ1QHJlZGhhdC5jb20+IHdyb3Rl
Og0KPj4+IA0KPj4+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPj4+IENBVVRJT046IEV4dGVybmFsIEVtYWlsDQo+
Pj4gDQo+Pj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+Pj4gDQo+Pj4gS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNo
YWhAbnV0YW5peC5jb20+IHdyaXRlczoNCj4+PiANCj4+Pj4+IE9uIDQgQXVnIDIwMjYsIGF0IDEy
OjIx4oCvUE0sIE1hcmt1cyBBcm1icnVzdGVyIDxhcm1icnVAcmVkaGF0LmNvbT4gd3JvdGU6DQo+
Pj4+PiANCj4+Pj4+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPj4+Pj4gQ0FVVElPTjogRXh0ZXJuYWwgRW1haWwN
Cj4+Pj4+IA0KPj4+Pj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+Pj4+PiANCj4+Pj4+IEtodXNoaXQgU2hhaCA8
a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPiB3cml0ZXM6DQo+Pj4+PiANCj4+Pj4+IFsuLi5dDQo+
Pj4+PiANCj4+Pj4+PiBTdHViIGZpbGUgd2FzIG1pc3Npbmcgb24gYXJtIHVzZXIgYnVpbGRzLiAN
Cj4+Pj4+PiANCj4+Pj4+PiBJIGhhdmUgZml4ZWQgdGhpcyBvbiB0aGUgcHJpdmF0ZSBicmFuY2gg
aWYgeW91IHdhbnQgdG8gdGFrZSBhIGxvb2suDQo+Pj4+PiANCj4+Pj4+IEknbSB3aWxsaW5nIHRv
IHB1bGwgYW4gdXBkYXRlIHRvIHYzLCBhc3N1bWluZyBpdCdzIGEgc21hbGwgZml4Lg0KPj4+PiAN
Cj4+Pj4gSXQgaXMgYSBzbWFsbCBmaXggOikNCj4+PiANCj4+PiBQbGVhc2UgdGVsbCBtZSB3aGF0
IHRvIHB1bGwuICBXaGVuIHlvdSdyZSByZWFkeSwgb2YgY291cnNlLg0KPj4gDQo+PiBJdOKAmXMg
b24gdGhlIHNhbWUgcHJpdmF0ZSBicmFuY2g6IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50
LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fZ2l0aHViLmNvbV9raHVzaGl0LTJEc2hhaC0yRG54X3Fl
bXVfdHJlZV91cHN0cmVhbS0yRHJmYy0yRHYzLTJEZml4dXBzJmQ9RHdJRmFRJmM9czg4M0dwVUNP
Q2hLT0hpb2NZdEdjZyZyPVBHV015aWduQTBOaURtVGx5UDd2T1RIb3pCd3NfVk44NnlyVm1TTWtC
cDAmbT1sdjQ2eWJvZFN0akF0ZGFwak13TG5vaEVEOS11UVNUM0tka3Z3WWVqOXloaUtZTnJSZHpE
eUhqZXVZcVV4ZHlnJnM9N0liY1N2MXBHTDI5UFRIQU94ajJsWldyMnR5U1FlUXFCODhxSHhsVHB2
RSZlPQ0KPiANCj4gQnVpbGRzLCBidXQgZmFpbHMgIm1ha2UgY2hlY2siIG9uIG15IGJveCAqc2ln
aCouDQo+IA0KPiB0ZXN0cy9xdGVzdC9xbXAtY21kLXRlc3QuYyBuZWVkcyBhbiB1cGRhdGUuDQoN
CjrigJkpDQoNCkZpeGVkIGl0LCBhdmFpbGFibGUgb246IA0KaHR0cHM6Ly9naXRodWIuY29tL2to
dXNoaXQtc2hhaC1ueC9xZW11L3RyZWUvdXBzdHJlYW0tcmZjLXYzLWZpeHVwcw0KDQpPbiBteSBt
YWNoaW5lLCBxZW11OnF0ZXN0K3F0ZXN0LWFhcmNoNjQgLyBxdGVzdC1hYXJjaDY0L2RldmljZS1p
bnRyb3NwZWN0LXRlc3QNCnN0aWxsIGZhaWxzLiAoSXQgd2lsbCBsaWtlbHkgbm90IGZhaWwgZm9y
IHlvdSBpZiB5b3UgYXJlIG9uIChhcm0gKyBrdm0gb3IgYW55DQpvdGhlciBBcmNoKSkNCg0KSSBo
YXZlIHJlcG9ydGVkIHRoaXMgdG8gRXJpYyBhcyB0aGUgZmFpbCBzdGVtcyBmcm9tIHRoZSBiYXNl
ICJjdXN0b21pemFibGUgaG9zdA0KbW9kZWzigJ0gc2VyaWVzLg0KDQpTb3JyeSBmb3IgdGhlIGhp
Y2N1cHMsIGFuZCB0aGFua3MgZm9yIHlvdXIgcGF0aWVuY2UsIHdpbGwgdGFrZSBjYXJlIGZyb20g
bm93IG9uLg0KDQoNCg0K
