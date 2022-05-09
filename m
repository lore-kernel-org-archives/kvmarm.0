Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F05C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 14:25:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7E4F4B2EF;
	Mon,  9 May 2022 10:25:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(invalid, public key: not available)
	header.i=@amperemail.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FaIKFKSdzWBj; Mon,  9 May 2022 10:25:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 109E64B1B5;
	Mon,  9 May 2022 10:25:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CB064B2E4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 09:37:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oehKyCruI6bX for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 09:37:51 -0400 (EDT)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2090.outbound.protection.outlook.com [40.107.93.90])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA66F4B2B0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 09:37:51 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9rQ/0TfLCQeh+8SoHP97HOW6rTt5dvoblNM2ULSHPdFkKnxvIHfR9SDDtmHU/GwN89E/dkqve6SR05w2TfKwc24U1t4a6nPML6xk7UudZPb/yoKD5Sv9tm7UjcB6JgDyzXcII1wJAnrZLawZ9LYdUmEe+l/pS6h7yjV0UvJkK+92n6SMO1iTkhhHmvrGvmkAktuFwsZhEvf6scYSNKJxyQx3fkRI7yIViF+3OL3U1ReDkpD4BjRagtO3IVm2iH8EqUy88pFUnus3xUf6l7PRJMgj4SeHdZkieBD70oN4SrylfZnbnDj2hrAD8sfCkgOzyxX9i7BTFhIchoLPSYG1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ff95JI19/gyQEjNfUa/WYjuVRsBll2sRmhFrmNGnG4A=;
 b=J80IPaIk+YZayDjbVm9ktkUHngrBwneD2kDFF5ondAlmISKQsp3IqxBsDTXvpxVx2txYkHYoQGM9yFVSwmV1EVV7PaHwS0d8YK0IySfemFfNhCr+XZ/DFyqyPAMEkkB0fY6BEi1rjvR58KPtUDw+/K5pWtt0EQ9dySYx7HTIVUnuLysCgg7EajeVp+gKjlVGQOa6ogMKDOuYeh5gl1vfXsChW8oQRQDjh2euExKCK8WcjCb7H/DJBi2+3QXvLQ+KHn+i0siFWeF5esZnAjhV24PvZPvayyzoQs9N6h1ExRgdn4m+4jAO4E2nIDg2kZeDGaedw8lQVDAHns/gXZKKHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff95JI19/gyQEjNfUa/WYjuVRsBll2sRmhFrmNGnG4A=;
 b=xno+wTw9gl7B/ia0G64NDWcCjdFUdbjNJ2soJevwkYOlkkc99936JpBa0xX7w7EJN8MHYSrC19QiCG/CdGf2O9i1PD9k/WtJv0MTX09Rmob799Zt2iFybNfD1EqdQNPt8htnrlKGOazkGkvEiA1bsMscpy/I+raEw3wVxKisHIg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from PH7PR01MB7608.prod.exchangelabs.com (2603:10b6:510:1d3::5) by
 DS7PR01MB7590.prod.exchangelabs.com (2603:10b6:8:72::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.21; Mon, 9 May 2022 13:37:49 +0000
Received: from PH7PR01MB7608.prod.exchangelabs.com
 ([fe80::e8eb:b7b1:f812:8ce]) by PH7PR01MB7608.prod.exchangelabs.com
 ([fe80::e8eb:b7b1:f812:8ce%3]) with mapi id 15.20.5164.020; Mon, 9 May 2022
 13:37:48 +0000
Message-ID: <7413d707-93a5-3681-e338-adebef198ec5@amperemail.onmicrosoft.com>
Date: Mon, 9 May 2022 09:37:41 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] ACPI/AEST: Initial AEST driver
Content-Language: en-US
To: "ishii.shuuichir@fujitsu.com" <ishii.shuuichir@fujitsu.com>,
 'Tyler Baicar' <baicar@os.amperecomputing.com>,
 "patches@amperecomputing.com" <patches@amperecomputing.com>,
 "abdulhamid@os.amperecomputing.com" <abdulhamid@os.amperecomputing.com>,
 "darren@os.amperecomputing.com" <darren@os.amperecomputing.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>,
 "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
 "rafael@kernel.org" <rafael@kernel.org>, "lenb@kernel.org"
 <lenb@kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "mark.rutland@arm.com"
 <mark.rutland@arm.com>, "anshuman.khandual@arm.com"
 <anshuman.khandual@arm.com>,
 "vincenzo.frascino@arm.com" <vincenzo.frascino@arm.com>,
 "tabba@google.com" <tabba@google.com>, "marcan@marcan.st"
 <marcan@marcan.st>, "keescook@chromium.org" <keescook@chromium.org>,
 "jthierry@redhat.com" <jthierry@redhat.com>,
 "masahiroy@kernel.org" <masahiroy@kernel.org>,
 "samitolvanen@google.com" <samitolvanen@google.com>,
 "john.garry@huawei.com" <john.garry@huawei.com>,
 "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>,
 "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
 "tmricht@linux.ibm.com" <tmricht@linux.ibm.com>,
 "dchinner@redhat.com" <dchinner@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Vineeth.Pillai@microsoft.com" <Vineeth.Pillai@microsoft.com>
References: <20211124170708.3874-1-baicar@os.amperecomputing.com>
 <20211124170708.3874-2-baicar@os.amperecomputing.com>
 <TYCPR01MB6160D05580A6E8C9510D25A5E9709@TYCPR01MB6160.jpnprd01.prod.outlook.com>
 <9330bbfb-d016-0283-a5ed-e2f4d5446759@amperemail.onmicrosoft.com>
 <TYCPR01MB616007723D2C8BA08F5337D2E9F59@TYCPR01MB6160.jpnprd01.prod.outlook.com>
From: Tyler Baicar <baicar@amperemail.onmicrosoft.com>
In-Reply-To: <TYCPR01MB616007723D2C8BA08F5337D2E9F59@TYCPR01MB6160.jpnprd01.prod.outlook.com>
X-ClientProxiedBy: CH2PR15CA0029.namprd15.prod.outlook.com
 (2603:10b6:610:51::39) To PH7PR01MB7608.prod.exchangelabs.com
 (2603:10b6:510:1d3::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bedd3fa-ac04-4387-8f43-08da31c11b34
X-MS-TrafficTypeDiagnostic: DS7PR01MB7590:EE_
X-Microsoft-Antispam-PRVS: <DS7PR01MB75906AFBB11402A3849515AAE3C69@DS7PR01MB7590.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7gjFDem9Pa3oY90FHco0El2DelbD9gEUKhhKZL6XPmVBUs3jeY7Yl7amB52SpS3P/4WLoeyVeUuONwS5zgJc3qaOYtetltGx8eHAPAmnnOSn3sTlZ/NljENPpEaay1BuiYRGqA4Lu95j2TbjGTiEcB51+CceVZjQLmi+A86MadqG/D/jpIDT5mKU2oBOiDeGuyeq+YdssiD+RWmMYGwlSLKFxE3OaA6hIpOBoAcyUevh8Xihji7AEkVjWb2P+JRkpayXzyLMgbYVc8jCQKTvqKh39W47RViM3aLn7jcl8fqT9gAFgXasR+VkKKcmsTr7ia5l0avzyMeS3m1u31DoL2CNZZ/0HgWYMW0WGTQefOS9Z0iQA1Cpza5cCI6Xw0xVgemrnVRonThdkCbnhN6DI+PbnQNV+3I4omw56ZlosswehKBYJlNMBOKB1nJEoccF55A2o5cshE+qFl+a9A6WYVOxdVhzPqbccEKcLKnsnrQdLYqLDOUOYAL3BTI6Mq/u/UXSs5guUi2OF+xTPK2tSp47lKMq4QKcjgMzvQ5UK7ccvKH0WAOWtZLjgBT6iKLhaZbopem/0KSFBcZRZZyiIvGKWJVInlC6brz0KDBdqbvB+z9bQesGEPtTvGm9VfzhFyyUcRXybgsHVu4kvTiEVe0Z50ZRkYkobOGPcPCpGSmRMBhcZe2ObUp0YF3QjVbOVet5pMn3tbc8Sj8olg9UEVqI/lsziNW1NC4Y6sx0VJLSVNRw/yeX0dVoLQgGsRFU
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH7PR01MB7608.prod.exchangelabs.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(110136005)(83170400001)(8936002)(7416002)(7406005)(31696002)(66946007)(66556008)(66476007)(5660300002)(8676002)(26005)(186003)(921005)(316002)(42882007)(2616005)(2906002)(38350700002)(38100700002)(53546011)(6666004)(6512007)(6506007)(52116002)(508600001)(31686004)(83380400001)(6486002)(43740500002);
 DIR:OUT; SFP:1102; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTQ2QW1ka3VqTS8vSnlBc0tVdFhLbHFMd0kwa0hIQktUdGQyV1ZmNktPd05I?=
 =?utf-8?B?Z0RsSzNGTUs1K3FuWFdxVzVRRTQ5d3Z5dmZBWTVlUHZhZnRuS014RFlTY1lW?=
 =?utf-8?B?TEhxeXM0OXBwNTc5bDBpbzlWZWdiL1VMWlM0VmdoNWRCYVJvODBEUWxWYm12?=
 =?utf-8?B?NTV2THQ0cEtEQndZeVN4U2FCNG9zTHU1UVNHZGk3VkNvZHY3Vmgxd3hDT0Rv?=
 =?utf-8?B?SUlXS0VqYjRTNkpZNTY4M1FmWlFvL2hubWM0eHYxNE8rV29JRG5qeitwZTNk?=
 =?utf-8?B?ZVJkK2J2MUVBTGRyTEZ2aFpTcm4rSmE1NnNjUzNlQVVhLzJtOVphME82TnJW?=
 =?utf-8?B?STFhWkVFeWt0NTAveVNJMW5nS1MrOUwvQnV3cnYxQVdreWt2N05Db2JZMDJP?=
 =?utf-8?B?YzVWVVFWR3VKNEFOand3bTdwZmFKMzZpWW1EUjE1aFdibmoraW0vR21zajF0?=
 =?utf-8?B?ZGdRdTVUQmRybGUyOStmYzFKR1NLVzRCS1lNclpKdmJMclhtZ2twdUREcWFn?=
 =?utf-8?B?MEpYSjlsU1g5bTZqWFczNytYWUpPMXpvdTByQWRnd05BWENSeEswdDF5SnF5?=
 =?utf-8?B?ZlB0ektQeDdsSitCY0FjT2FscnkxdGQ0dUV1RWhveGZzZy9BWllGOEc2bHV4?=
 =?utf-8?B?QmlKdzgwSlBQK09KRndxdHlSMzNyNTd5UTdvWWZvbElGNklKQTI1VE1WcUds?=
 =?utf-8?B?aDN5b05EV0NxV3U0WG9vKzRDMXc5ODFROTBKaFgzbUtZS0drL1dFL0NwY2RX?=
 =?utf-8?B?QXRKc0FWWjVDUWNGUGxEUVdvaXZIbEFrdlFpb3RWaVovdFpRSWthUFRSbzky?=
 =?utf-8?B?WnFyTDI1M0dTWG0yOUQzOUVVa2JrVFAzaXdxMXlHOTd6VHdwUWw1VnJMa1gw?=
 =?utf-8?B?eURkRSs3blJvV3dRR1IvaDJCZU5BVzFuNXdhdnBUZHl4cmRQSWFpdStjWEJF?=
 =?utf-8?B?NHNiNzA0alIwL04vYWxVTVF3T3pIREJxVnBpWHFsTFNlRW82VVhlNW0vTDZy?=
 =?utf-8?B?ZkNiMDZSVjFzWS9yWHhuSEJjNGZwNHREcmNQeTg1Q2VyUmZzTTc0VHlpdzd0?=
 =?utf-8?B?UmdLOUFqWDJHTzcrVUlWYm16bUpBaE9pQTBRa0VxQVpyN2pHTnYyWkt3Yzd5?=
 =?utf-8?B?RFFDcGphMStlRjMvaUpyVmpSclZwR3lRUDRJOWE0dnI1ZGFYYXJmc0xLclh4?=
 =?utf-8?B?TGo2aFZwd2JUQ21IdFVUTHJndDZOY2VSNStzK2VHcjNOcGl5aDZTdWpOVHRN?=
 =?utf-8?B?ZGdLZ2J6YVFIb1BPZ1doMkFYdzdJMklFVnl2em9DNUJLTy9yUTJ0cFgxWlJL?=
 =?utf-8?B?U0xWaWdHTVJxYURma2dOSUp6WjN4SHljRHp1V3NUYTBEaDhadjFKdlRLT2Zz?=
 =?utf-8?B?SW43STNVeHRiSGdUYk44bk5pTCtuRGtMUjRxam5ucGlETkN2QkZvdjBPT1kv?=
 =?utf-8?B?enFtNzNzOS9FV1RwRmFPT045cnhSZWsya1BmYytvWmZhb0FXKzVwM3NzdDhx?=
 =?utf-8?B?NHh1WkVUdjZmTnY1dlVGV3QvQXNjc052MlBNc01hb1Q2cktYNVMvQU95NWF5?=
 =?utf-8?B?OGtoTXBKeGtwRzFEYTA3L2JPa1BNdXhlZ1U1VCs0Y2EvME1oOFdEVjFqeTRu?=
 =?utf-8?B?NGVuaG9pU01nR0huZW50d21iMmg5NGpGWE1QeGtPWHFUdFZOL0tVSWRYYm1V?=
 =?utf-8?B?bncxbFZRc3dhVStpK0N5YlVVL0hrb1RCZXAza2hFUW83UXJqb0o2eXFSdW9B?=
 =?utf-8?B?YU5SbzVaS1RLNUlXM0FzVEdKdHNjN2tibWFFV3lTaUdQNnlDMWprUTBQQ2J2?=
 =?utf-8?B?VnlTWDRBTVI3dHBtQkZJWFFXOFFrMDRqNGRrZXZUbGZGR2VrV3hwZ1N5RzQ5?=
 =?utf-8?B?a2pPdndUd0FJTGF4YThqM0pJM1hPdjJOL1hXMTZpcnlyZEhYM3NSdUFDcFgr?=
 =?utf-8?B?ekNuaHVxSTUxdEljQzlNcXh1UUNsejNrbStmMTVuSmxwSGVQVjc1MXlHMzRT?=
 =?utf-8?B?U1BjbzJlbVJQWEYyYjJlWDE5Qzhudy9VSzlTUlpha1RudU9TblMvdW43bGsx?=
 =?utf-8?B?L3BXQXpBUXdqOFBuRm9ycG84dDVZck9SM2R0TExMV1RmMjltSmNWNDI1b3JE?=
 =?utf-8?B?eXlldjRIeG5mV1ZIUDlGQ0RRKzFoY1NzOGY1YnJtZkZOcHdUalJGdlF5S1dU?=
 =?utf-8?B?dWdHRnFzYnZBanhycWVCVFZ0WjNhYTBXaXMwQ0hHZlZYQkwyQTFXaGtMWnZp?=
 =?utf-8?B?RWpZL1pCQWdjNlRYREQrNG1XOGdnWGM1NnRVZHVMT3hjMUhzTzI1RnYwdU9m?=
 =?utf-8?B?dEMyMXd0cmNOQ1B4UzliN0JGdEY3LzZuajJLdExwaDdJVWhkZFlmR0RaOEpM?=
 =?utf-8?Q?WuzLvdlJOzKldddmTg5kgw4qUB/sBQ8jr8lAZ?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bedd3fa-ac04-4387-8f43-08da31c11b34
X-MS-Exchange-CrossTenant-AuthSource: PH7PR01MB7608.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:37:48.8844 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eDaicKRH3gyuXkmmufvqwfBv4b5k533V4VDoa3nCKdotZnPG6h8CbrqDfnwUWbTtSHOUz0imON/rd/3Ms98CSVxuKaYye+WeOb1D2OpERR+u9gHAryLexDNnoDEg9BC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR01MB7590
X-Mailman-Approved-At: Mon, 09 May 2022 10:25:05 -0400
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgU2h1dWljaGlyb3UsCgpJIHNob3VsZCBiZSBhYmxlIHRvIGdldCBhIHYyIHBhdGNoIHNlcmll
cyBvdXQgYnkgdGhlIGVuZCBvZiB0aGUgbW9udGguCgpUaGFua3MsClR5bGVyCgpPbiA0LzIwLzIw
MjIgMzo1NCBBTSwgaXNoaWkuc2h1dWljaGlyQGZ1aml0c3UuY29tIHdyb3RlOgo+IEhpLCBUeWxl
ci4KPiAKPiBXaGVuIGRvIHlvdSBwbGFuIHRvIHBvc3QgdGhlIHYyIHBhdGNoIHNlcmllcz8KPiBQ
bGVhc2UgbGV0IG1lIGtub3cgaWYgeW91IGRvbid0IG1pbmQuCj4gCj4gQmVzdCByZWdhcmRzLgo+
IAo+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQo+PiBGcm9tOiBUeWxlciBCYWljYXIgPGJh
aWNhckBhbXBlcmVtYWlsLm9ubWljcm9zb2Z0LmNvbT4KPj4gU2VudDogRnJpZGF5LCBEZWNlbWJl
ciAxNywgMjAyMSA4OjMzIEFNCj4+IFRvOiBJc2hpaSwgU2h1dWljaGlyb3Uv55+z5LqVIOWRqOS4
gOmDjiA8aXNoaWkuc2h1dWljaGlyQGZ1aml0c3UuY29tPjsgJ1R5bGVyIEJhaWNhcicKPj4gPGJh
aWNhckBvcy5hbXBlcmVjb21wdXRpbmcuY29tPjsgcGF0Y2hlc0BhbXBlcmVjb21wdXRpbmcuY29t
Owo+PiBhYmR1bGhhbWlkQG9zLmFtcGVyZWNvbXB1dGluZy5jb207IGRhcnJlbkBvcy5hbXBlcmVj
b21wdXRpbmcuY29tOwo+PiBjYXRhbGluLm1hcmluYXNAYXJtLmNvbTsgd2lsbEBrZXJuZWwub3Jn
OyBtYXpAa2VybmVsLm9yZzsKPj4gamFtZXMubW9yc2VAYXJtLmNvbTsgYWxleGFuZHJ1LmVsaXNl
aUBhcm0uY29tOyBzdXp1a2kucG91bG9zZUBhcm0uY29tOwo+PiBsb3JlbnpvLnBpZXJhbGlzaUBh
cm0uY29tOyBndW9oYW5qdW5AaHVhd2VpLmNvbTsgc3VkZWVwLmhvbGxhQGFybS5jb207Cj4+IHJh
ZmFlbEBrZXJuZWwub3JnOyBsZW5iQGtlcm5lbC5vcmc7IHRvbnkubHVja0BpbnRlbC5jb207IGJw
QGFsaWVuOC5kZTsKPj4gbWFyay5ydXRsYW5kQGFybS5jb207IGFuc2h1bWFuLmtoYW5kdWFsQGFy
bS5jb207Cj4+IHZpbmNlbnpvLmZyYXNjaW5vQGFybS5jb207IHRhYmJhQGdvb2dsZS5jb207IG1h
cmNhbkBtYXJjYW4uc3Q7Cj4+IGtlZXNjb29rQGNocm9taXVtLm9yZzsganRoaWVycnlAcmVkaGF0
LmNvbTsgbWFzYWhpcm95QGtlcm5lbC5vcmc7Cj4+IHNhbWl0b2x2YW5lbkBnb29nbGUuY29tOyBq
b2huLmdhcnJ5QGh1YXdlaS5jb207IGRhbmllbC5sZXpjYW5vQGxpbmFyby5vcmc7Cj4+IGdvckBs
aW51eC5pYm0uY29tOyB6aGFuZ3NoYW9rdW5AaGlzaWxpY29uLmNvbTsgdG1yaWNodEBsaW51eC5p
Ym0uY29tOwo+PiBkY2hpbm5lckByZWRoYXQuY29tOyB0Z2x4QGxpbnV0cm9uaXguZGU7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7Cj4+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFk
ZWFkLm9yZzsga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdTsKPj4gbGludXgtYWNwaUB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWVkYWNAdmdlci5rZXJuZWwub3JnOwo+PiBWaW5lZXRoLlBpbGxh
aUBtaWNyb3NvZnQuY29tCj4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8yXSBBQ1BJL0FFU1Q6IElu
aXRpYWwgQUVTVCBkcml2ZXIKPj4KPj4gSGkgU2h1dWljaGlyb3UsCj4+Cj4+IFRoYW5rIHlvdSBm
b3IgeW91ciBmZWVkYmFjayEKPj4KPj4gT24gMTIvOS8yMDIxIDM6MTAgQU0sIGlzaGlpLnNodXVp
Y2hpckBmdWppdHN1LmNvbSB3cm90ZToKPj4+IEhpLCBUeWxlci4KPj4+Cj4+PiBXZSB3b3VsZCBs
aWtlIHRvIG1ha2UgYSBmZXcgY29tbWVudHMuCj4+Pgo+Pj4+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tCj4+Pj4gRnJvbTogVHlsZXIgQmFpY2FyIDxiYWljYXJAb3MuYW1wZXJlY29tcHV0aW5n
LmNvbT4KPj4+PiBTZW50OiBUaHVyc2RheSwgTm92ZW1iZXIgMjUsIDIwMjEgMjowNyBBTQo+Pj4+
IFRvOiBwYXRjaGVzQGFtcGVyZWNvbXB1dGluZy5jb207IGFiZHVsaGFtaWRAb3MuYW1wZXJlY29t
cHV0aW5nLmNvbTsKPj4+PiBkYXJyZW5Ab3MuYW1wZXJlY29tcHV0aW5nLmNvbTsgY2F0YWxpbi5t
YXJpbmFzQGFybS5jb207Cj4+Pj4gd2lsbEBrZXJuZWwub3JnOyBtYXpAa2VybmVsLm9yZzsgamFt
ZXMubW9yc2VAYXJtLmNvbTsKPj4+PiBhbGV4YW5kcnUuZWxpc2VpQGFybS5jb207IHN1enVraS5w
b3Vsb3NlQGFybS5jb207Cj4+Pj4gbG9yZW56by5waWVyYWxpc2lAYXJtLmNvbTsgZ3VvaGFuanVu
QGh1YXdlaS5jb207Cj4+Pj4gc3VkZWVwLmhvbGxhQGFybS5jb207IHJhZmFlbEBrZXJuZWwub3Jn
OyBsZW5iQGtlcm5lbC5vcmc7Cj4+Pj4gdG9ueS5sdWNrQGludGVsLmNvbTsgYnBAYWxpZW44LmRl
OyBtYXJrLnJ1dGxhbmRAYXJtLmNvbTsKPj4+PiBhbnNodW1hbi5raGFuZHVhbEBhcm0uY29tOyB2
aW5jZW56by5mcmFzY2lub0Bhcm0uY29tOwo+Pj4+IHRhYmJhQGdvb2dsZS5jb207IG1hcmNhbkBt
YXJjYW4uc3Q7IGtlZXNjb29rQGNocm9taXVtLm9yZzsKPj4+PiBqdGhpZXJyeUByZWRoYXQuY29t
OyBtYXNhaGlyb3lAa2VybmVsLm9yZzsgc2FtaXRvbHZhbmVuQGdvb2dsZS5jb207Cj4+Pj4gam9o
bi5nYXJyeUBodWF3ZWkuY29tOyBkYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnOyBnb3JAbGludXgu
aWJtLmNvbTsKPj4+PiB6aGFuZ3NoYW9rdW5AaGlzaWxpY29uLmNvbTsgdG1yaWNodEBsaW51eC5p
Ym0uY29tOwo+Pj4+IGRjaGlubmVyQHJlZGhhdC5jb207IHRnbHhAbGludXRyb25peC5kZTsKPj4+
PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmlu
ZnJhZGVhZC5vcmc7Cj4+Pj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdTsgbGludXgtYWNw
aUB2Z2VyLmtlcm5lbC5vcmc7Cj4+Pj4gbGludXgtZWRhY0B2Z2VyLmtlcm5lbC5vcmc7IElzaGlp
LCBTaHV1aWNoaXJvdS/nn7PkupUKPj4+PiDlkajkuIDpg44gPGlzaGlpLnNodXVpY2hpckBmdWpp
dHN1LmNvbT47IFZpbmVldGguUGlsbGFpQG1pY3Jvc29mdC5jb20KPj4+PiBDYzogVHlsZXIgQmFp
Y2FyIDxiYWljYXJAb3MuYW1wZXJlY29tcHV0aW5nLmNvbT4KPj4+PiBTdWJqZWN0OiBbUEFUQ0gg
MS8yXSBBQ1BJL0FFU1Q6IEluaXRpYWwgQUVTVCBkcml2ZXIKPj4+Pgo+Pj4+IEFkZCBzdXBwb3J0
IGZvciBwYXJzaW5nIHRoZSBBUk0gRXJyb3IgU291cmNlIFRhYmxlIGFuZCBiYXNpYyBoYW5kbGlu
Zwo+Pj4+IG9mIGVycm9ycyByZXBvcnRlZCB0aHJvdWdoIGJvdGggbWVtb3J5IG1hcHBlZCBhbmQg
c3lzdGVtIHJlZ2lzdGVyCj4+IGludGVyZmFjZXMuCj4+Pj4KPj4+PiBBc3N1bWUgc3lzdGVtIHJl
Z2lzdGVyIGludGVyZmFjZXMgYXJlIG9ubHkgcmVnaXN0ZXJlZCB3aXRoIHByaXZhdGUKPj4+PiBw
ZXJpcGhlcmFsIGludGVycnVwdHMgKFBQSXMpOyBvdGhlcndpc2UgdGhlcmUgaXMgbm8gZ3VhcmFu
dGVlIHRoZQo+Pj4+IGNvcmUgaGFuZGxpbmcgdGhlIGVycm9yIGlzIHRoZSBjb3JlIHdoaWNoIHRv
b2sgdGhlIGVycm9yIGFuZCBoYXMgdGhlCj4+Pj4gc3luZHJvbWUgaW5mbyBpbiBpdHMgc3lzdGVt
IHJlZ2lzdGVycy4KPj4+Pgo+Pj4+IEFkZCBsb2dnaW5nIGZvciBhbGwgZGV0ZWN0ZWQgZXJyb3Jz
IGFuZCB0cmlnZ2VyIGEga2VybmVsIHBhbmljIGlmCj4+Pj4gdGhlcmUgaXMgYW55IHVuY29ycmVj
dGVkIGVycm9yIHByZXNlbnQuCj4+Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBUeWxlciBCYWljYXIg
PGJhaWNhckBvcy5hbXBlcmVjb21wdXRpbmcuY29tPgo+Pj4+IC0tLQo+Pj4gWy4uLl0KPj4+Cj4+
Pj4gK3N0YXRpYyBpbnQgX19pbml0IGFlc3RfaW5pdF9ub2RlKHN0cnVjdCBhY3BpX2Flc3RfaGRy
ICpub2RlKSB7Cj4+Pj4gKwl1bmlvbiBhY3BpX2Flc3RfcHJvY2Vzc29yX2RhdGEgKnByb2NfZGF0
YTsKPj4+PiArCXVuaW9uIGFlc3Rfbm9kZV9zcGVjICpub2RlX3NwZWM7Cj4+Pj4gKwlzdHJ1Y3Qg
YWVzdF9ub2RlX2RhdGEgKmRhdGE7Cj4+Pj4gKwlpbnQgcmV0Owo+Pj4+ICsKPj4+PiArCWRhdGEg
PSBremFsbG9jKHNpemVvZihzdHJ1Y3QgYWVzdF9ub2RlX2RhdGEpLCBHRlBfS0VSTkVMKTsKPj4+
PiArCWlmICghZGF0YSkKPj4+PiArCQlyZXR1cm4gLUVOT01FTTsKPj4+PiArCj4+Pj4gKwlkYXRh
LT5ub2RlX3R5cGUgPSBub2RlLT50eXBlOwo+Pj4+ICsKPj4+PiArCW5vZGVfc3BlYyA9IEFDUElf
QUREX1BUUih1bmlvbiBhZXN0X25vZGVfc3BlYywgbm9kZSwKPj4+PiBub2RlLT5ub2RlX3NwZWNp
ZmljX29mZnNldCk7Cj4+Pj4gKwo+Pj4+ICsJc3dpdGNoIChub2RlLT50eXBlKSB7Cj4+Pj4gKwlj
YXNlIEFDUElfQUVTVF9QUk9DRVNTT1JfRVJST1JfTk9ERToKPj4+PiArCQltZW1jcHkoJmRhdGEt
PmRhdGEsIG5vZGVfc3BlYywgc2l6ZW9mKHN0cnVjdAo+Pj4+IGFjcGlfYWVzdF9wcm9jZXNzb3Ip
KTsKPj4+PiArCQlicmVhazsKPj4+PiArCWNhc2UgQUNQSV9BRVNUX01FTU9SWV9FUlJPUl9OT0RF
Ogo+Pj4+ICsJCW1lbWNweSgmZGF0YS0+ZGF0YSwgbm9kZV9zcGVjLCBzaXplb2Yoc3RydWN0Cj4+
Pj4gYWNwaV9hZXN0X21lbW9yeSkpOwo+Pj4+ICsJCWJyZWFrOwo+Pj4+ICsJY2FzZSBBQ1BJX0FF
U1RfU01NVV9FUlJPUl9OT0RFOgo+Pj4+ICsJCW1lbWNweSgmZGF0YS0+ZGF0YSwgbm9kZV9zcGVj
LCBzaXplb2Yoc3RydWN0Cj4+Pj4gYWNwaV9hZXN0X3NtbXUpKTsKPj4+PiArCQlicmVhazsKPj4+
PiArCWNhc2UgQUNQSV9BRVNUX1ZFTkRPUl9FUlJPUl9OT0RFOgo+Pj4+ICsJCW1lbWNweSgmZGF0
YS0+ZGF0YSwgbm9kZV9zcGVjLCBzaXplb2Yoc3RydWN0Cj4+Pj4gYWNwaV9hZXN0X3ZlbmRvcikp
Owo+Pj4+ICsJCWJyZWFrOwo+Pj4+ICsJY2FzZSBBQ1BJX0FFU1RfR0lDX0VSUk9SX05PREU6Cj4+
Pj4gKwkJbWVtY3B5KCZkYXRhLT5kYXRhLCBub2RlX3NwZWMsIHNpemVvZihzdHJ1Y3QKPj4+PiBh
Y3BpX2Flc3RfZ2ljKSk7Cj4+Pj4gKwkJYnJlYWs7Cj4+Pj4gKwlkZWZhdWx0Ogo+Pj4+ICsJCWtm
cmVlKGRhdGEpOwo+Pj4+ICsJCXJldHVybiAtRUlOVkFMOwo+Pj4+ICsJfQo+Pj4+ICsKPj4+PiAr
CWlmIChub2RlLT50eXBlID09IEFDUElfQUVTVF9QUk9DRVNTT1JfRVJST1JfTk9ERSkgewo+Pj4+
ICsJCXByb2NfZGF0YSA9IEFDUElfQUREX1BUUih1bmlvbiBhY3BpX2Flc3RfcHJvY2Vzc29yX2Rh
dGEsCj4+Pj4gbm9kZV9zcGVjLAo+Pj4+ICsJCQkJCSBzaXplb2YoYWNwaV9hZXN0X3Byb2Nlc3Nv
cikpOwo+Pj4+ICsKPj4+PiArCQlzd2l0Y2ggKGRhdGEtPmRhdGEucHJvY2Vzc29yLnJlc291cmNl
X3R5cGUpIHsKPj4+PiArCQljYXNlIEFDUElfQUVTVF9DQUNIRV9SRVNPVVJDRToKPj4+PiArCQkJ
bWVtY3B5KCZkYXRhLT5wcm9jX2RhdGEsIHByb2NfZGF0YSwKPj4+PiArCQkJICAgICAgIHNpemVv
ZihzdHJ1Y3QgYWNwaV9hZXN0X3Byb2Nlc3Nvcl9jYWNoZSkpOwo+Pj4+ICsJCQlicmVhazsKPj4+
PiArCQljYXNlIEFDUElfQUVTVF9UTEJfUkVTT1VSQ0U6Cj4+Pj4gKwkJCW1lbWNweSgmZGF0YS0+
cHJvY19kYXRhLCBwcm9jX2RhdGEsCj4+Pj4gKwkJCSAgICAgICBzaXplb2Yoc3RydWN0IGFjcGlf
YWVzdF9wcm9jZXNzb3JfdGxiKSk7Cj4+Pj4gKwkJCWJyZWFrOwo+Pj4+ICsJCWNhc2UgQUNQSV9B
RVNUX0dFTkVSSUNfUkVTT1VSQ0U6Cj4+Pj4gKwkJCW1lbWNweSgmZGF0YS0+cHJvY19kYXRhLCBw
cm9jX2RhdGEsCj4+Pj4gKwkJCSAgICAgICBzaXplb2Yoc3RydWN0IGFjcGlfYWVzdF9wcm9jZXNz
b3JfZ2VuZXJpYykpOwo+Pj4+ICsJCQlicmVhazsKPj4+PiArCQl9Cj4+Pj4gKwl9Cj4+Pj4gKwo+
Pj4+ICsJcmV0ID0gYWVzdF9pbml0X2ludGVyZmFjZShub2RlLCBkYXRhKTsKPj4+PiArCWlmIChy
ZXQpIHsKPj4+PiArCQlrZnJlZShkYXRhKTsKPj4+PiArCQlyZXR1cm4gcmV0Owo+Pj4+ICsJfQo+
Pj4+ICsKPj4+PiArCXJldHVybiBhZXN0X2luaXRfaW50ZXJydXB0cyhub2RlLCBkYXRhKTsKPj4+
IElmIGFlc3RfaW5pdF9pbnRlcnJ1cHRzKCkgZmFpbGVkLCBpcyBpdCBuZWNlc3NhcnkgdG8gcmVs
ZWFzZSB0aGUgZGF0YQo+Pj4gcG9pbnRlciBhY3F1aXJlZCBieSBremFsbG9jPwo+PiBhZXN0X2lu
aXRfaW50ZXJydXB0cygpIHJldHVybnMgYW4gZXJyb3IgaWYgYW55IG9mIHRoZSBpbnRlcnJ1cHRz
IGluIHRoZSBpbnRlcnJ1cHQgbGlzdAo+PiBmYWlscywgYnV0IGl0J3MgcG9zc2libGUgdGhhdCBz
b21lIGludGVycnVwdHMgaW4gdGhlIGxpc3QgcmVnaXN0ZXJlZCBzdWNjZXNzZnVsbHkuIFNvCj4+
IHdlIGF0dGVtcHQgdG8ga2VlcCBjaHVnZ2luZyBhbG9uZyBpbiB0aGF0IHNjZW5hcmlvIGJlY2F1
c2Ugc29tZSBpbnRlcnJ1cHRzIG1heQo+PiBiZSBlbmFibGVkIGFuZCByZWdpc3RlcmVkIHdpdGgg
dGhlIGludGVyZmFjZSBzdWNjZXNzZnVsbHkuIElmIGFueSBpbnRlcnJ1cHQKPj4gcmVnaXN0cmF0
aW9uIGZhaWxzLCB0aGVyZSB3aWxsIGJlIGEgcHJpbnQgbm90aWZ5aW5nIHRoYXQgdGhlcmUgd2Fz
IGEgZmFpbHVyZSB3aGVuCj4+IGluaXRpYWxpemluZyB0aGF0IG5vZGUuCj4+Pj4gK30KPj4+PiAr
Cj4+Pj4gK3N0YXRpYyB2b2lkIGFlc3RfY291bnRfcHBpKHN0cnVjdCBhY3BpX2Flc3RfaGRyICpu
b2RlKQo+Pj4+ICt7Cj4+Pj4gKwlzdHJ1Y3QgYWNwaV9hZXN0X25vZGVfaW50ZXJydXB0ICppbnRl
cnJ1cHQ7Cj4+Pj4gKwlpbnQgaTsKPj4+PiArCj4+Pj4gKwlpbnRlcnJ1cHQgPSBBQ1BJX0FERF9Q
VFIoc3RydWN0IGFjcGlfYWVzdF9ub2RlX2ludGVycnVwdCwgbm9kZSwKPj4+PiArCQkJCSBub2Rl
LT5ub2RlX2ludGVycnVwdF9vZmZzZXQpOwo+Pj4+ICsKPj4+PiArCWZvciAoaSA9IDA7IGkgPCBu
b2RlLT5ub2RlX2ludGVycnVwdF9jb3VudDsgaSsrLCBpbnRlcnJ1cHQrKykgewo+Pj4+ICsJCWlm
IChpbnRlcnJ1cHQtPmdzaXYgPj0gMTYgJiYgaW50ZXJydXB0LT5nc2l2IDwgMzIpCj4+Pj4gKwkJ
CW51bV9wcGkrKzsKPj4+PiArCX0KPj4+PiArfQo+Pj4+ICsKPj4+PiArc3RhdGljIGludCBhZXN0
X3N0YXJ0aW5nX2NwdSh1bnNpZ25lZCBpbnQgY3B1KQo+Pj4+ICt7Cj4+Pj4gKwlpbnQgaTsKPj4+
PiArCj4+Pj4gKwlmb3IgKGkgPSAwOyBpIDwgbnVtX3BwaTsgaSsrKQo+Pj4+ICsJCWVuYWJsZV9w
ZXJjcHVfaXJxKHBwaV9pcnFzW2ldLCBJUlFfVFlQRV9OT05FKTsKPj4+PiArCj4+Pj4gKwlyZXR1
cm4gMDsKPj4+PiArfQo+Pj4+ICsKPj4+PiArc3RhdGljIGludCBhZXN0X2R5aW5nX2NwdSh1bnNp
Z25lZCBpbnQgY3B1KQo+Pj4+ICt7Cj4+PiBXb3VsZG4ndCBpdCBiZSBiZXR0ZXIgdG8gZXhlY3V0
ZSBkaXNhYmxlX3BlcmNwdV9pcnEoKSwgd2hpY2ggaXMgcGFpcmVkCj4+PiB3aXRoIGVuYWJsZV9w
ZXJjcHVfaXJxKCksIGluIGFlc3RfZHlpbmdfY3B1KCk/Cj4+Cj4+IEdvb2QgcG9pbnQuIEkgd2ls
bCBhZGQgdGhhdCBpbiB0aGUgbmV4dCB2ZXJzaW9uLgo+Pgo+PiBUaGFua3MsCj4+Cj4+IFR5bGVy
Cj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
