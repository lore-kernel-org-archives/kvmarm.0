Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2042.outbound.protection.outlook.com [40.107.241.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0F20E002
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 14:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738678105; cv=fail; b=fWXHiqA/JyZ6/8eGKu3JGHx1UR/dIvO2oTCyvP9rvr5PJQXMd1hmqHptSXET5+TkwPe1sSNMdsCo/eO7GKKKt91ARDJ29l5gCzBisC/fsbpzN96EMrXOosdv6k1CBfKXukQtUEvvFMZkkhKfZ93+SG8Fnwe6CcYXWjBxRnTE5to=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738678105; c=relaxed/simple;
	bh=T+4Jbgsa10siagWeu7GUilflynCbBfw8j8UmixXQSDs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dXP9f6YJIT6Njg+AgPIo9+3XyQZTFr9K8gIsmm/6SRVyUi6h0D/ZQFRCm0c+GdMX+Sj4TCm0TCYmye4C2ox5zKh40TxVV4x+cDMD5aaslXfdTeWo4SHCmdN6brHvCrwXUGf400vciW4UJKG+sfLGDGof6pAs4xXZXDfrhOMgX88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=HdUtbArF; arc=fail smtp.client-ip=40.107.241.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="HdUtbArF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSBbgOZ+OzJROnVViF0IdziJaNZvIJX8IpWcg7oXSQ1RLqJqFrGD0PmgA13uVFoaSJLoBIGH+Rb5dr9weeXoW1UXmIHMPnUhc0B7/vBXw8tYzPm7rfnbaTs8vhx/efVZ9mbv8Tde7XOPkh2zLe0OODx5jTqdsjfz47LJfkXy6NQpgYhvMLPaGCoNLdJstnjNazwG608R/6mtI8xxN8x+kOyI8KmsaGJNrulXYgiYw0NSnq4fUj51ZIzEvOT54L6oOsN4QrdMaVbaIyT3fvhmGkm3Zd7V2ovD3+9g1T14NWU4wILVbG8w9cJtfJZJ2PqPI0goHk+0aPuIiHE3/txL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+4Jbgsa10siagWeu7GUilflynCbBfw8j8UmixXQSDs=;
 b=O+xqOujE56szVorQnstECwPVIxpa+DfZvbskHLRR4UaPaxaBbtgUU9+G7FTMPgB4IwucM4aLsdyiG68W+zi7qtsTX5AayHo7xMdIrBiVghxslyP0UIafv8CI33DZ8NiWX61Ruj29M1DTy/YPt0g3czibVmcFJaobA6kPoBakL6ie0oOfGHmeZ7UYRIDnZ2F8JOg+IZiTAD0h8+fpnqSrTmArwdLEOOC08ugA+ICDzEgayIQANEFdUU7Up7UAlDdS+GU/RulQC61F8K+4uYv+ssDbkXOAG/LKs4RJioJ+Q2WJGQJWKiFJGMpSPE/zNWpjgzxvXfABbweJDeFxT1TnEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+4Jbgsa10siagWeu7GUilflynCbBfw8j8UmixXQSDs=;
 b=HdUtbArFQOho+yotDSVSbOv2oMZ09A6OH1pLd1C0b/Q7C0iDGQiLdBxN26joVQJcT44/WH1iqlAXwt3HvwdzUFuZHBjVbGq/DN4GKekqfml4ntKeMqrgqFM7nv9mWZLVuRdYer8g3jR3nSsiweo+cPfgBVfmHoLsLK7OYjOqKQhfQ7wUQxcGa+4asUW7pebbtrN4EeGJ9S3Ni8ax4hcBBmzK+DxbyY76EEEvNRTU3goG3jOZjqhOyQIADqRsx9K7RPY5EhPLlruYAtflcRlppQGO6znxLJyFZbQmSSx3wrOpE5/tRzdQ4fO97qx0if7RBhiNrM4O8W3pI3PjCQW5jQ==
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com (2603:10a6:20b:5a2::12)
 by VI1PR03MB6576.eurprd03.prod.outlook.com (2603:10a6:800:19e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.23; Tue, 4 Feb
 2025 14:08:20 +0000
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803]) by AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 14:08:19 +0000
From: Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>
To: Marc Zyngier <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Volodymyr Babchuk
	<Volodymyr_Babchuk@epam.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: timer: Always evaluate the need for a
 soft timer
Thread-Topic: [PATCH 1/3] KVM: arm64: timer: Always evaluate the need for a
 soft timer
Thread-Index: AQHbcaAkKn6xeubK/0aPUqfD8Bh0y7M3OToA
Date: Tue, 4 Feb 2025 14:08:19 +0000
Message-ID: <6e16e01d-73db-464f-b8c8-84539cdd5525@epam.com>
References: <20250128161721.3279927-1-maz@kernel.org>
 <20250128161721.3279927-2-maz@kernel.org>
In-Reply-To: <20250128161721.3279927-2-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR03MB9438:EE_|VI1PR03MB6576:EE_
x-ms-office365-filtering-correlation-id: 49e33f2b-8482-47d7-0d9a-08dd452560dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UUt1cjRpdndYZ0oydGxONnd5bFN0UlVHVWJxK0JpQUtjcENpUDQ3c3lsT0Nx?=
 =?utf-8?B?SllNNEpNQ2NXMDY4dlRoK2FlV0JRdktKWFBnRFlEYmV4ZGVIRUxXZDllbTRz?=
 =?utf-8?B?c1VFb3RpYU9sa3l6RFFYTlZtd0Rxa3NsQXNkN2xJZXFGQUh5dmxDc09lNmsv?=
 =?utf-8?B?ak5uU1lkZGxmWjdtUjBna1NEbDNxWGlQZmd5RmFCOURGZnFiU3BKay94OWVh?=
 =?utf-8?B?Nkl0TkRoaVlOTXNwcnZxSGw4V0ZjaHRPNDRUNnpENmlvNkZzOFE1TlVjMHd5?=
 =?utf-8?B?S05JaStFYTVOd1pOYUl3czd3ZUNrRTFyRkxNNjI3K3NML3g0MnJ6TElmMTRT?=
 =?utf-8?B?OW51S3I4cml3ZGhXb3ZQaWptQXZxaHpNQWRTUEh0WTNMRGdOSzVyTjZJUUtw?=
 =?utf-8?B?d2FydUVub1FEV0RWTXVST3kzditVZ1ZVOXZlTUR6NlluYUVPMTk4M0NWWlBo?=
 =?utf-8?B?dUlBamJ3ZDRJV3ZUVDRWVmpoRTlCdG85bDVUZThjaFFvOVlzVnhDSUZUR0p0?=
 =?utf-8?B?U1BFUlk2NWZTQWsvMTBNY1kyOHYvdXA0L2QzVmN2em5JMExmMU14bVo1aTBL?=
 =?utf-8?B?emwyNmozTG9rM0ZtWHNCYnZkb25zQklwVmxUcWQ3QWVnTWdNTG1Bd2gwMHF2?=
 =?utf-8?B?TlJvTnBaZG9wSkdLNEp1RjFsR3ZpYmFiNXNnZStWQnVPMTJ2VENqSzNaaFV6?=
 =?utf-8?B?eGk3NnRaeDk3L0dFMEVEcWp6TmZWaU0vb2Z6TVA0b2QzVFJpQkZobkpqU1Nk?=
 =?utf-8?B?ZlAyVlZUNDJ6NWIwdGg1aWRxNjFHaCtoOVorc2twVlJvbkdQR2RycXVrT3gv?=
 =?utf-8?B?aEVDYVEvRjlIMFFGNmhSNlZyM1ZrUkxxTENIVmFvQkpXUkNoTWJLdFNqVXFJ?=
 =?utf-8?B?VktvaXJ5RmNnRldKRVZwcFpYUHFhLzZ3TjRFaDZRNGtaZXF6ejN1SlVJYSs1?=
 =?utf-8?B?RDF5dnY1VVZkYWpFN1dVc1RVNEVDUjFNdTFLYkNyQlBveW5zMk00c01LSkRq?=
 =?utf-8?B?YnU2ZUtyT1hRc1V0ZW80VW9DeEIwSHhBTzV6QjBtS0U0OFFOSFl1Z0kva1pR?=
 =?utf-8?B?YzZmdnd0ZjZXZnREd2J5RzkwdzdIcTBJT1d0MjJmNGRZRE9sdVB5TVd0NW5y?=
 =?utf-8?B?TEcvd1RPeTU1Q3FXSjBTdUpuSE5weXhCWUFiZzd0KzAzS0p1SzZDdWIyNmVD?=
 =?utf-8?B?d2psV29uSFJuN0FKbEs3WjVwUG8yQ0xCWmoyaEMvYWtkYUhBdlZVVkdtTXBW?=
 =?utf-8?B?VXJENkFBNHNNdDErUmNrTEJ4cEY0aERVR1ZmclVyZmdoMlh0Z2hvYTg3RjZ3?=
 =?utf-8?B?YlBvQTVlR2E3QXFweTZJS1JoeklMY28xSjMwMnJzUW9wQlRwTFJQQlB0a2pZ?=
 =?utf-8?B?LzA3Uk1xSmNjQXdqRzRGamN5RFNzZk9TWEthSGtQWXVEcFBHc2x6Ylp4dktU?=
 =?utf-8?B?dzdxLzhZRkRSalFvYWpGVVV2QVRaLzBMZ0JaVXYydVZsQ3ZGcWYxcWtNYkJL?=
 =?utf-8?B?RVVhNFRvVjIwNXFFWEw5YmZ6NGFXaTNZbXNQT1dITHN5ZTQ3MnhwS0VtOE1J?=
 =?utf-8?B?ZHVjajRRQzczNXZ4SjQ0RGw2ZzR2N3Y5VG9UaXBDdEk3SjVzY3JTNDhIbm8y?=
 =?utf-8?B?YnppVzRuZUxBOWtoTGZDSjFTSjIrSG5YWW5EQTNuTDN4Z1gwanNsZ3d1RjY4?=
 =?utf-8?B?Z3VNR3Q4UnAxMjU1TTdNZTRPUmdweDNyVlpvSmFYZTM1ZDg0alB1Q0poeUZQ?=
 =?utf-8?B?WUZvdWdneXcvc2REYWNqRHFodFl3VW93ZjBkWGhsbHlMekFjVFJqZ1JNN2VT?=
 =?utf-8?B?OFpRTUZNbTFncklMU2FSQlh6Sk9zOTdkVXJEcGdkZytkR2dHOUM2R1U3UWZo?=
 =?utf-8?B?YzZSZ1hKRnZTYzFuQmRWcStVOXBVYzdleCtPdnh3R0ZHU0NTRWRic3Nydkpn?=
 =?utf-8?Q?TNghi77+t94vATsB9WUrh4zfmQNQjckv?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB9438.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cFBMTWUyT0FYdE5DcVJENkxCdHBZTURJa09DckVnUXRmNUZYU2Vicmp4Tmtr?=
 =?utf-8?B?Q3ErUmNqbkh0NWY2NURYUnMzQTNEVmpRdEhTK0o1ZS9iditGM0o3Ukg1RmJ1?=
 =?utf-8?B?dTh2VWV6WUJUNC9DWHNCTVlrWWU4WTJpYzExZmZPN0UwOHNkRG0rRlV5UmxD?=
 =?utf-8?B?QVlzM0hPZEVaMjFzd00yOThac3l6Yk1VZzNZb2VGNms5UDRPbkNpRkE0ZkJS?=
 =?utf-8?B?cDZhNnljVGpwcW5MSVNPN21adzRET1BqOXRvMG5xanVUdzJHT3l0OThBamlZ?=
 =?utf-8?B?TGMvQTc0NXAxYzBVN2U1VkxLWFBwRzg1VWp5RWRKMk5tTW1UMmpxZkJLWTI2?=
 =?utf-8?B?a0VuQzNIeklBaStKSjJOUE41VTRwUCtxYU55WDNtQld3U2E5TG5ZdXphWHda?=
 =?utf-8?B?V3VSeEp3QkhZeEtEWEhvQVYrUEp1UFVZM0h4MFdXSEdRZytYUHlzay8vVW9V?=
 =?utf-8?B?d2o3ZFRVOFo0c1VWRWdrd0VLYWlZeWdjb2ZFbjgrNGVzanpvYWZnN25DR3FH?=
 =?utf-8?B?QkJTVmlISDFtNlBUejlMOS9DWWNuRm5KZ1J1aGp2RDZTaVBJd2R2ZzNEeXhk?=
 =?utf-8?B?d2tLWEVka2YyZVRIUytjQWRhQzlkU01VQUFVTDBjZGNsQzhZU0JXMGtJTFY5?=
 =?utf-8?B?YzQxdWpmYnpBdDJDcGF5dHh1RGlqV0R0emozTHM0TTJYZk1wWFRtTmZGT09i?=
 =?utf-8?B?L1Z1ZjVRQTlCK3ZiaWxTSlF2TE91THJwbkMzeDFzRm5XamlQZGpoZmxxVGlI?=
 =?utf-8?B?bVJOWXNBY3NQYlNSdC9OWG1FVGxmbWt4YVgzL0dYRThkU0JieEViOFE3QXo0?=
 =?utf-8?B?YW1iN2FQSU9od2dCekhzM2NlRGVCb1VnUkVQNlhRUkRTK1hjN2FxZkdBaE11?=
 =?utf-8?B?S294bFgxRVdmREN2aGJJUk5aYmlqWld1TS9RT0JmZVFkUnJaUjU2aGo4Y0xu?=
 =?utf-8?B?YW96bS9TOWtsVm1TYWhNTjZsMnhPdEtITEgvMk1WQ1RvTGxPQWIxMHRhME9P?=
 =?utf-8?B?VGd4eGFKZzE5WEQ0NTZNbTA0MWIrUndPVU1vbUpkbFVGeS9qK2NiamdQdGJC?=
 =?utf-8?B?L1dvSjFqOUlhTDFnUUdVekRtbHZzRFFQaDh5aEZoclhaZ3VydnlJUzdhYzB5?=
 =?utf-8?B?Q2lIL1l4UzE3TnkxV1ZiUk1KcVJNYWZkbVBaREdrSjNHMGtkY3NzRm0vby9M?=
 =?utf-8?B?aXp3ZXM2VmJja3VETlhnWjZCc2pkYUZwY3Z2MGRqNWpmQTNaemtGUUZ6NTUw?=
 =?utf-8?B?cy9ZK1VyYTVSZGZzL1RDaWdteUl6UlZTQit4aGZBcXBwaTlwbmZTZXlCTjR2?=
 =?utf-8?B?NEdOamhNQVN1UFRXajJIWC95K3o5SUZoeGZaYkdsVnJFalNoZ1dnY0JEL3lE?=
 =?utf-8?B?TDNVdGE5L3o0RXc0Um83ZkNIMFhUWHA0MlFURFdKQzlrc3dIZWRlQTk2STNl?=
 =?utf-8?B?K1k4aDVpQXNleHh4SWZhcnlvUG9oRFpjMzNKSWRzSzAvS2xsbyt1UjdmUWhK?=
 =?utf-8?B?QzdSaXgzblIxbW9YSkN1ZHh3UFB5YjZPbkhDQTRKK3RuVWIrZVdOckN5WVQz?=
 =?utf-8?B?VmhpUFJraFZMSEdIeXNjYnlWeFJYanpRVEV2OG1oaWl0c0RjOFk1SDcyVzZy?=
 =?utf-8?B?RzRxUW5UL2I0NGFlZmh4ZS8wZWNqT0MvYUpkVWN6bFFOZUg5YUZnNzBTOW1R?=
 =?utf-8?B?YkpYUEkyclBpVm1zVUpodVEwQ1hpcUxybFgxTHg4NkpiSUliTnY2am42SnZ1?=
 =?utf-8?B?dDkweEQvNFMwbGJnZEtxdG51YzVVQjBPU0lURjJFL1lTVmpSaVNSM3ozQVRy?=
 =?utf-8?B?Q255TGpIUzEzaFZiR1E2RXJ3QWFCTkhGUlIwNlUwZmlZS2paWlJOUS9zN1Bv?=
 =?utf-8?B?UGhzVXVHV1NMNThPRDhIa2ZZL3RxY1lTK2pQNWRTd0JPajd1eTMxRWZod1Zp?=
 =?utf-8?B?V0FlY2xwN1NReW12Y3pMaTU4bkFSZUc0US9GVkJJYlZKVEgwVjhqZDFYaDRy?=
 =?utf-8?B?Tm1jWVRYaHFKTzl6enRCcjI5ZUZSOFlyWjFsd3FFeVhHeXZFWndTZGdnVFJz?=
 =?utf-8?B?bDkwNEg5YXdDdTNETmVtU2p3ck0rQ2Q4NDZxK2JGdWFpVFR4VkFoN1padjNZ?=
 =?utf-8?B?T05vTU9Cbjl5blpsWlNMNGNRbEVTMHM0NGlpSzJlZGlTbVg4MDR0Q3dyUmZX?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB1F490D62ABEF449C88337133A05227@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR03MB9438.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49e33f2b-8482-47d7-0d9a-08dd452560dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2025 14:08:19.7132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eehlekW65Pq0yIeyQVFismMo6S3qfOnETVOs5bruzXqUT4oF4BX8sHBYDEQAgvXS7/qTAC+0PcwNNUCFmyy/qjrNvRnkCKayRDLlUIF8Rek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6576

SGVsbG8sIE1hcmMuDQoNCk9uIDEvMjgvMjUgMTg6MTcsIE1hcmMgWnluZ2llciB3cm90ZToNCj4g
V2hlbiB1cGRhdGluZyB0aGUgaW50ZXJydXB0IHN0YXRlIGZvciBhbiBlbXVsYXRlZCB0aW1lciwg
d2UgcmV0dXJuDQo+IGVhcmx5IGFuZCBza2lwIHRoZSBzZXR1cCBvZiBhIHNvZnQgdGltZXIgdGhh
dCBydW5zIGluIHBhcmFsbGVsDQo+IHdpdGggdGhlIGd1ZXN0Lg0KPg0KPiBXaGlsZSB0aGlzIGlz
IE9LIGlmIHdlIGhhdmUgc2V0IHRoZSBpbnRlcnJ1cHQgcGVuZGluZywgaXQgaXMgcHJldHR5DQo+
IHdyb25nIGlmIHRoZSBndWVzdCBtb3ZlZCBDVkFMIGludG8gdGhlIGZ1dHVyZS4gIEluIHRoYXQg
Y2FzZSwNCj4gbm8gdGltZXIgaXMgYXJtZWQgYW5kIHRoZSBndWVzdCBjYW4gd2FpdCBmb3IgYSB2
ZXJ5IGxvbmcgdGltZQ0KPiAoaXQgd2lsbCB0YWtlIGEgZnVsbCBwdXQvbG9hZCBjeWNsZSBmb3Ig
dGhlIHNpdHVhdGlvbiB0byByZXNvbHZlKS4NCj4NCj4gVGhpcyBpcyBzcGVjaWFsbHkgdmlzaWJs
ZSB3aXRoIEVESzIgcnVubmluZyBhdCBFTDIsIGJ1dCBzdGlsbA0KPiB1c2luZyB0aGUgRUwxIHZp
cnR1YWwgdGltZXIsIHdoaWNoIGluIHRoYXQgY2FzZSBpcyBmdWxseSBlbXVsYXRlZC4NCj4gQW55
IGtleS1wcmVzcyB0YWtlcyBhZ2VzIHRvIGJlIGNhcHR1cmVkLCBhcyB0aGVyZSBpcyBubyBVQVJU
DQo+IGludGVycnVwdCBhbmQgRURLMiByZWxpZXMgb24gcG9sbGluZyBmcm9tIGEgdGltZXIuLi4N
Cj4NCj4gVGhlIGZpeCBpcyBzaW1wbHkgdG8gZHJvcCB0aGUgZWFybHkgcmV0dXJuLiBJZiB0aGUg
dGltZXIgaW50ZXJydXB0DQo+IGlzIHBlbmRpbmcsIHdlIHdpbGwgc3RpbGwgcmV0dXJuIGVhcmx5
LCBhbmQgb3RoZXJ3aXNlIGFybSB0aGUgc29mdA0KPiB0aW1lci4NCj4NCj4gRml4ZXM6IDRkNzRl
Y2ZhNjQ1OGIgKCJLVk06IGFybTY0OiBEb24ndCBhcm0gYSBocnRpbWVyIGZvciBhbiBhbHJlYWR5
IHBlbmRpbmcgdGltZXIiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJu
ZWwub3JnPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KVGVzdGVkLWJ5OiBEbXl0cm8g
VGVybGV0c2t5aSA8ZG15dHJvX3RlcmxldHNreWlAZXBhbS5jb20+DQo+IC0tLQ0KPiAgIGFyY2gv
YXJtNjQva3ZtL2FyY2hfdGltZXIuYyB8IDQgKy0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMyBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
a3ZtL2FyY2hfdGltZXIuYyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0KPiBpbmRleCBk
M2QyNDMzNjY1MzZjLi4wMzVlNDNmNWQ0ZjlhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0L2t2
bS9hcmNoX3RpbWVyLmMNCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jDQo+IEBA
IC00NzEsMTAgKzQ3MSw4IEBAIHN0YXRpYyB2b2lkIHRpbWVyX2VtdWxhdGUoc3RydWN0IGFyY2hf
dGltZXJfY29udGV4dCAqY3R4KQ0KPiAgIA0KPiAgIAl0cmFjZV9rdm1fdGltZXJfZW11bGF0ZShj
dHgsIHNob3VsZF9maXJlKTsNCj4gICANCj4gLQlpZiAoc2hvdWxkX2ZpcmUgIT0gY3R4LT5pcnEu
bGV2ZWwpIHsNCj4gKwlpZiAoc2hvdWxkX2ZpcmUgIT0gY3R4LT5pcnEubGV2ZWwpDQo+ICAgCQlr
dm1fdGltZXJfdXBkYXRlX2lycShjdHgtPnZjcHUsIHNob3VsZF9maXJlLCBjdHgpOw0KPiAtCQly
ZXR1cm47DQo+IC0JfQ0KPiAgIA0KPiAgIAlrdm1fdGltZXJfdXBkYXRlX3N0YXR1cyhjdHgsIHNo
b3VsZF9maXJlKTsNCj4gICA=
