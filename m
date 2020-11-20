Return-Path: <SRS0=rD/S=E2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8182C5519F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 12:01:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 333F722253
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 12:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 333F722253
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F604B2C3;
	Fri, 20 Nov 2020 07:01:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JJGGV-mC2epW; Fri, 20 Nov 2020 07:00:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 236D84B27F;
	Fri, 20 Nov 2020 07:00:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E88BF4B272
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 07:00:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3W0G-CUGJ+R2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2020 07:00:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CE474B26F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 07:00:56 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DF6811D4;
 Fri, 20 Nov 2020 04:00:55 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 107DC3F718;
 Fri, 20 Nov 2020 04:00:54 -0800 (PST)
To: kvm@vger.kernel.org,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Andrew Jones <drjones@redhat.com>, Auger Eric <eric.auger@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests] its-migration segmentation fault
Message-ID: <d18ab1d5-4eff-43e1-4a5b-5373b67e4286@arm.com>
Date: Fri, 20 Nov 2020 12:02:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Language: en-US
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

V2hlbiBydW5uaW5nIGFsbCB0aGUgdGVzdHMgd2l0aCB0YXNrc2V0IC1jIDAtMyAuL3J1bl90ZXN0
cy5zaCBvbiBhIHJvY2twcm82NCAob24KdGhlIENvcnRleC1hNTMgY29yZXMpIHRoZSBpdHMtbWln
cmF0aW9uIHRlc3QgaGFuZ3MuIEluIHRoZSBsb2cgZmlsZSBJIHNlZToKCnJ1bl9taWdyYXRpb24g
dGltZW91dCAtayAxcyAtLWZvcmVncm91bmQgOTBzIC91c3IvYmluL3FlbXUtc3lzdGVtLWFhcmNo
NjQKLW5vZGVmYXVsdHMgLW1hY2hpbmUgdmlydCxnaWMtdmVyc2lvbj1ob3N0LGFjY2VsPWt2bSAt
Y3B1IGhvc3QgLWRldmljZQp2aXJ0aW8tc2VyaWFsLWRldmljZSAtZGV2aWNlIHZpcnRjb25zb2xl
LGNoYXJkZXY9Y3RkIC1jaGFyZGV2IHRlc3RkZXYsaWQ9Y3RkCi1kZXZpY2UgcGNpLXRlc3RkZXYg
LWRpc3BsYXkgbm9uZSAtc2VyaWFsIHN0ZGlvIC1rZXJuZWwgYXJtL2dpYy5mbGF0IC1zbXAgNgot
bWFjaGluZSBnaWMtdmVyc2lvbj0zIC1hcHBlbmQgaXRzLW1pZ3JhdGlvbiAjIC1pbml0cmQgL3Rt
cC90bXAuT3JsUWlvckJwWQpJVFM6IE1BUEQgZGV2aWQ9MiBzaXplID0gMHg4IGl0dD0weDQwNDIw
MDAwIHZhbGlkPTEKSVRTOiBNQVBEIGRldmlkPTcgc2l6ZSA9IDB4OCBpdHQ9MHg0MDQzMDAwMCB2
YWxpZD0xCk1BUEMgY29sX2lkPTMgdGFyZ2V0X2FkZHIgPSAweDMwMDAwIHZhbGlkPTEKTUFQQyBj
b2xfaWQ9MiB0YXJnZXRfYWRkciA9IDB4MjAwMDAgdmFsaWQ9MQpJTlZBTEwgY29sX2lkPTIKSU5W
QUxMIGNvbF9pZD0zCk1BUFRJIGRldl9pZD0yIGV2ZW50X2lkPTIwIC0+IHBoeXNfaWQ9ODE5NSwg
Y29sX2lkPTMKTUFQVEkgZGV2X2lkPTcgZXZlbnRfaWQ9MjU1IC0+IHBoeXNfaWQ9ODE5NiwgY29s
X2lkPTIKTm93IG1pZ3JhdGUgdGhlIFZNLCB0aGVuIHByZXNzIGEga2V5IHRvIGNvbnRpbnVlLi4u
CnNjcmlwdHMvYXJjaC1ydW4uYmFzaDogbGluZSAxMDM6IDQ4NTQ5IERvbmXCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlY2hvICd7ICJleGVjdXRlIjoKInFtcF9jYXBhYmls
aXRpZXMiIH17ICJleGVjdXRlIjonICIkMiIgJ30nCsKgwqDCoMKgIDQ4NTUwIFNlZ21lbnRhdGlv
biBmYXVsdMKgwqDCoMKgwqAgKGNvcmUgZHVtcGVkKSB8IG5jYXQgLVUgJDEKc2NyaXB0cy9hcmNo
LXJ1bi5iYXNoOiBsaW5lIDEwMzogNDg1NjggRG9uZcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGVjaG8gJ3sgImV4ZWN1dGUiOgoicW1wX2NhcGFiaWxpdGllcyIgfXsgImV4
ZWN1dGUiOicgIiQyIiAnfScKwqDCoMKgwqAgNDg1NjkgU2VnbWVudGF0aW9uIGZhdWx0wqDCoMKg
wqDCoCAoY29yZSBkdW1wZWQpIHwgbmNhdCAtVSAkMQpzY3JpcHRzL2FyY2gtcnVuLmJhc2g6IGxp
bmUgMTAzOiA0ODU4MyBEb25lwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
ZWNobyAneyAiZXhlY3V0ZSI6CiJxbXBfY2FwYWJpbGl0aWVzIiB9eyAiZXhlY3V0ZSI6JyAiJDIi
ICd9JwrCoMKgwqDCoCA0ODU4NCBTZWdtZW50YXRpb24gZmF1bHTCoMKgwqDCoMKgIChjb3JlIGR1
bXBlZCkgfCBuY2F0IC1VICQxClsuLl0Kc2NyaXB0cy9hcmNoLXJ1bi5iYXNoOiBsaW5lIDEwMzog
NDk0MTQgRG9uZcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVjaG8gJ3sg
ImV4ZWN1dGUiOgoicW1wX2NhcGFiaWxpdGllcyIgfXsgImV4ZWN1dGUiOicgIiQyIiAnfScKwqDC
oMKgwqAgNDk0MTUgU2VnbWVudGF0aW9uIGZhdWx0wqDCoMKgwqDCoCAoY29yZSBkdW1wZWQpIHwg
bmNhdCAtVSAkMQpxZW11LXN5c3RlbS1hYXJjaDY0OiB0ZXJtaW5hdGluZyBvbiBzaWduYWwgMTUg
ZnJvbSBwaWQgNDg0OTYgKHRpbWVvdXQpCnFlbXUtc3lzdGVtLWFhcmNoNjQ6IHRlcm1pbmF0aW5n
IG9uIHNpZ25hbCAxNSBmcm9tIHBpZCA0ODUwNCAodGltZW91dCkKc2NyaXB0cy9hcmNoLXJ1bi5i
YXNoOiBsaW5lIDEwMzogNDk0MzAgRG9uZcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGVjaG8gJ3sgImV4ZWN1dGUiOgoicW1wX2NhcGFiaWxpdGllcyIgfXsgImV4ZWN1dGUi
OicgIiQyIiAnfScKwqDCoMKgwqAgNDk0MzEgU2VnbWVudGF0aW9uIGZhdWx0wqDCoMKgwqDCoCAo
Y29yZSBkdW1wZWQpIHwgbmNhdCAtVSAkMQpzY3JpcHRzL2FyY2gtcnVuLmJhc2g6IGxpbmUgMTAz
OiA0OTQ0NSBEb25lwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZWNobyAn
eyAiZXhlY3V0ZSI6CiJxbXBfY2FwYWJpbGl0aWVzIiB9eyAiZXhlY3V0ZSI6JyAiJDIiICd9Jwpb
Li5dCgpJZiBJIHJ1biB0aGUgdGVzdCBtYW51YWxseToKCiQgdGFza3NldCAtYyAwLTMgLi9hcm0t
cnVuIGFybS9naWMuZmxhdCAtc21wIDQgLW1hY2hpbmUgZ2ljLXZlcnNpb249MyAtYXBwZW5kCidp
dHMtbWlncmF0aW9uJwoKL3Vzci9iaW4vcWVtdS1zeXN0ZW0tYWFyY2g2NCAtbm9kZWZhdWx0cyAt
bWFjaGluZSB2aXJ0LGdpYy12ZXJzaW9uPWhvc3QsYWNjZWw9a3ZtCi1jcHUgaG9zdCAtZGV2aWNl
IHZpcnRpby1zZXJpYWwtZGV2aWNlIC1kZXZpY2UgdmlydGNvbnNvbGUsY2hhcmRldj1jdGQgLWNo
YXJkZXYKdGVzdGRldixpZD1jdGQgLWRldmljZSBwY2ktdGVzdGRldiAtZGlzcGxheSBub25lIC1z
ZXJpYWwgc3RkaW8gLWtlcm5lbAphcm0vZ2ljLmZsYXQgLXNtcCA0IC1tYWNoaW5lIGdpYy12ZXJz
aW9uPTMgLWFwcGVuZCBpdHMtbWlncmF0aW9uICMgLWluaXRyZAovdG1wL3RtcC5PdHNUajNRRDRK
CklUUzogTUFQRCBkZXZpZD0yIHNpemUgPSAweDggaXR0PTB4NDAzYTAwMDAgdmFsaWQ9MQpJVFM6
IE1BUEQgZGV2aWQ9NyBzaXplID0gMHg4IGl0dD0weDQwM2IwMDAwIHZhbGlkPTEKTUFQQyBjb2xf
aWQ9MyB0YXJnZXRfYWRkciA9IDB4MzAwMDAgdmFsaWQ9MQpNQVBDIGNvbF9pZD0yIHRhcmdldF9h
ZGRyID0gMHgyMDAwMCB2YWxpZD0xCklOVkFMTCBjb2xfaWQ9MgpJTlZBTEwgY29sX2lkPTMKTUFQ
VEkgZGV2X2lkPTIgZXZlbnRfaWQ9MjAgLT4gcGh5c19pZD04MTk1LCBjb2xfaWQ9MwpNQVBUSSBk
ZXZfaWQ9NyBldmVudF9pZD0yNTUgLT4gcGh5c19pZD04MTk2LCBjb2xfaWQ9MgpOb3cgbWlncmF0
ZSB0aGUgVk0sIHRoZW4gcHJlc3MgYSBrZXkgdG8gY29udGludWUuLi4KCkFuZCB0aGUgdGVzdCBo
YW5ncyBoZXJlIGFmdGVyIEkgcHJlc3MgYSBrZXkuCgpQYWNrYWdlIHZlcnNpb25zOgoKJCBuY2F0
IC0tdmVyc2lvbgpOY2F0OiBWZXJzaW9uIDcuOTEgKCBodHRwczovL25tYXAub3JnL25jYXQgKQoK
JCAvdXNyL2Jpbi9xZW11LXN5c3RlbS1hYXJjaDY0IC0tdmVyc2lvbgpRRU1VIGVtdWxhdG9yIHZl
cnNpb24gNS4xLjAKQ29weXJpZ2h0IChjKSAyMDAzLTIwMjAgRmFicmljZSBCZWxsYXJkIGFuZCB0
aGUgUUVNVSBQcm9qZWN0IGRldmVsb3BlcnMKCiQgdW5hbWUgLWEKTGludXggcm9ja3BybyA1LjEw
LjAtcmM0ICMzMyBTTVAgUFJFRU1QVCBUaHUgTm92IDE5IDE1OjU4OjU3IEdNVCAyMDIwIGFhcmNo
NjQKR05VL0xpbnV4CgpUaGFua3MsCgpBbGV4CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
