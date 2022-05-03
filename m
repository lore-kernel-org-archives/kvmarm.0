Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274B0C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 17:14:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A10D34B137;
	Tue,  3 May 2022 13:14:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nLvdzQ6vQ9nb; Tue,  3 May 2022 13:14:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C6F14B12C;
	Tue,  3 May 2022 13:14:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 459BD49ECC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 13:14:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3oKuWZMYm2ae for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 13:14:29 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 902FE49EE8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 13:14:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651598069;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=25yruawK82BRU8PPmLT07Lb5GnX+f2J1Ef9rIEwDi98=;
 b=B1OVLbejCBZGfCdXUWuc2aw+H12rH5LvxhpLUHzclxq+J56OXhb+3XSZi9gWmFZ8GHAMaf
 Y95FU4V45b4Y+YW9rIdMw0k58F7MPetF3QLSk449PHE+6NgY8JH14b+TLlndMA1B8b74ey
 KU31zCR5Cu9sVoCPUOutKePxZonRiU4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-ipFZUin6Nqqloy5oJhqz2g-1; Tue, 03 May 2022 13:14:28 -0400
X-MC-Unique: ipFZUin6Nqqloy5oJhqz2g-1
Received: by mail-wr1-f72.google.com with SMTP id
 w11-20020adf8bcb000000b0020c550ba8d7so3011645wra.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 10:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=25yruawK82BRU8PPmLT07Lb5GnX+f2J1Ef9rIEwDi98=;
 b=XGn0AWBfYLAGzafJXfsOGumxDYXahdka/W8MZO3PFvhmkIwxEkW4OPsAfMMsfbMPsH
 HUEd0nj08QBs2LKaTXL7xlpFiEnXPqiOtd0YXBRvWFq4s8Ag8XqpKxVci6FqCe0MABz1
 EtWmPouPOUxceMSjN9vrmxq47KOjbbx75o9/n73R0FQ6dYtq7o2fEkf6mREunKNXwjid
 PPGwKefipveJf2L0N5zAbSqFU+A/R4uPmrVzMY5K+ZdyYUdHsCu/iZ5mbI0Yy+0oL6sM
 ncTPloYka//Hq5z15NzAhjrGGxu8SWjbNN+hjb5DYeEimjgeOblSgKmgoHUs/nEtoxVR
 uMfQ==
X-Gm-Message-State: AOAM531mfm57Xj28IGLaTNroALnXeRGYywhirHclHPuMf5EOrUSAS5/O
 RaG08yY4xkMaX3GgOAPwQZ8RBMeGDLiMDOIJKJJax7H2sxirXFIjI8CqfrZQte9zD4MJ/TdIVfg
 4TOUDVWly/aUQ3GAWaAb/6q0M
X-Received: by 2002:adf:dc41:0:b0:205:8df5:464c with SMTP id
 m1-20020adfdc41000000b002058df5464cmr12717031wrj.445.1651598066884; 
 Tue, 03 May 2022 10:14:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp+8F7z9GHuGzIhq2lALuMJAAd+ac92PrS3GkXeyK/gh4fux9ihDLCHNWr3aNse5TC7eJquw==
X-Received: by 2002:adf:dc41:0:b0:205:8df5:464c with SMTP id
 m1-20020adfdc41000000b002058df5464cmr12717009wrj.445.1651598066613; 
 Tue, 03 May 2022 10:14:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 l12-20020a7bcf0c000000b003942a244ee3sm1863346wmg.40.2022.05.03.10.14.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 03 May 2022 10:14:26 -0700 (PDT)
Message-ID: <da752e67-1fff-e27f-bcaf-e29aaa536532@redhat.com>
Date: Tue, 3 May 2022 19:14:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic: Check that new ITEs could be
 saved in guest memory
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-2-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220427184814.2204513-2-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: andre.przywara@arm.com, pshier@google.com, maz@kernel.org,
 pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

SGkgUmljYXJkbywKCk9uIDQvMjcvMjIgMjA6NDgsIFJpY2FyZG8gS29sbGVyIHdyb3RlOgo+IFRy
eSB0byBpbXByb3ZlIHRoZSBwcmVkaWN0YWJpbGl0eSBvZiBJVFMgc2F2ZS9yZXN0b3JlcyBieSBm
YWlsaW5nCj4gY29tbWFuZHMgdGhhdCB3b3VsZCBsZWFkIHRvIGZhaWxlZCBzYXZlcy4gTW9yZSBz
cGVjaWZpY2FsbHksIGZhaWwgYW55Cj4gY29tbWFuZCB0aGF0IGFkZHMgYW4gZW50cnkgaW50byBh
biBJVFMgdGFibGUgdGhhdCBpcyBub3QgaW4gZ3Vlc3QKPiBtZW1vcnksIHdoaWNoIHdvdWxkIG90
aGVyd2lzZSBsZWFkIHRvIGEgZmFpbGVkIElUUyBzYXZlIGlvY3RsLiBUaGVyZQo+IGFyZSBhbHJl
YWR5IGNoZWNrcyBmb3IgY29sbGVjdGlvbiBhbmQgZGV2aWNlIGVudHJpZXMsIGJ1dCBub3QgZm9y
Cj4gSVRFcy4gIEFkZCB0aGUgY29ycmVzcG9uZGluZyBjaGVjayBmb3IgdGhlIElUVCB3aGVuIGFk
ZGluZyBJVEVzLgo+Cj4gU2lnbmVkLW9mZi1ieTogUmljYXJkbyBLb2xsZXIgPHJpY2Fya29sQGdv
b2dsZS5jb20+Cj4gLS0tCj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYyB8IDUxICsr
KysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDM3IGlu
c2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy1pdHMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYwo+IGlu
ZGV4IDJlMTM0MDJiZTNiZC4uZTE0NzkwNzUwOTU4IDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy1pdHMuYwo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMu
Ywo+IEBAIC04OTQsNiArODk0LDE4IEBAIHN0YXRpYyBpbnQgdmdpY19pdHNfY21kX2hhbmRsZV9t
b3ZpKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHZnaWNfaXRzICppdHMsCj4gIAlyZXR1cm4gdXBk
YXRlX2FmZmluaXR5KGl0ZS0+aXJxLCB2Y3B1KTsKPiAgfQo+ICAKPiArc3RhdGljIGJvb2wgX19p
c192aXNpYmxlX2dmbl9sb2NrZWQoc3RydWN0IHZnaWNfaXRzICppdHMsIGdwYV90IGdwYSkKPiAr
ewo+ICsJZ2ZuX3QgZ2ZuID0gZ3BhID4+IFBBR0VfU0hJRlQ7Cj4gKwlpbnQgaWR4Owo+ICsJYm9v
bCByZXQ7Cj4gKwo+ICsJaWR4ID0gc3JjdV9yZWFkX2xvY2soJml0cy0+ZGV2LT5rdm0tPnNyY3Up
Owo+ICsJcmV0ID0ga3ZtX2lzX3Zpc2libGVfZ2ZuKGl0cy0+ZGV2LT5rdm0sIGdmbik7Cj4gKwlz
cmN1X3JlYWRfdW5sb2NrKCZpdHMtPmRldi0+a3ZtLT5zcmN1LCBpZHgpOwo+ICsJcmV0dXJuIHJl
dDsKPiArfQo+ICsKPiAgLyoKPiAgICogQ2hlY2sgd2hldGhlciBhbiBJRCBjYW4gYmUgc3RvcmVk
IGludG8gdGhlIGNvcnJlc3BvbmRpbmcgZ3Vlc3QgdGFibGUuCj4gICAqIEZvciBhIGRpcmVjdCB0
YWJsZSB0aGlzIGlzIHByZXR0eSBlYXN5LCBidXQgZ2V0cyBhIGJpdCBuYXN0eSBmb3IKPiBAQCAt
OTA4LDkgKzkyMCw3IEBAIHN0YXRpYyBib29sIHZnaWNfaXRzX2NoZWNrX2lkKHN0cnVjdCB2Z2lj
X2l0cyAqaXRzLCB1NjQgYmFzZXIsIHUzMiBpZCwKPiAgCXU2NCBpbmRpcmVjdF9wdHIsIHR5cGUg
PSBHSVRTX0JBU0VSX1RZUEUoYmFzZXIpOwo+ICAJcGh5c19hZGRyX3QgYmFzZSA9IEdJVFNfQkFT
RVJfQUREUl80OF90b181MihiYXNlcik7Cj4gIAlpbnQgZXN6ID0gR0lUU19CQVNFUl9FTlRSWV9T
SVpFKGJhc2VyKTsKPiAtCWludCBpbmRleCwgaWR4Owo+IC0JZ2ZuX3QgZ2ZuOwo+IC0JYm9vbCBy
ZXQ7Cj4gKwlpbnQgaW5kZXg7Cj4gIAo+ICAJc3dpdGNoICh0eXBlKSB7Cj4gIAljYXNlIEdJVFNf
QkFTRVJfVFlQRV9ERVZJQ0U6Cj4gQEAgLTkzMywxMiArOTQzLDExIEBAIHN0YXRpYyBib29sIHZn
aWNfaXRzX2NoZWNrX2lkKHN0cnVjdCB2Z2ljX2l0cyAqaXRzLCB1NjQgYmFzZXIsIHUzMiBpZCwK
PiAgCQkJcmV0dXJuIGZhbHNlOwo+ICAKPiAgCQlhZGRyID0gYmFzZSArIGlkICogZXN6Owo+IC0J
CWdmbiA9IGFkZHIgPj4gUEFHRV9TSElGVDsKPiAgCj4gIAkJaWYgKGVhZGRyKQo+ICAJCQkqZWFk
ZHIgPSBhZGRyOwo+ICAKPiAtCQlnb3RvIG91dDsKPiArCQlyZXR1cm4gX19pc192aXNpYmxlX2dm
bl9sb2NrZWQoaXRzLCBhZGRyKTsKPiAgCX0KPiAgCj4gIAkvKiBjYWxjdWxhdGUgYW5kIGNoZWNr
IHRoZSBpbmRleCBpbnRvIHRoZSAxc3QgbGV2ZWwgKi8KPiBAQCAtOTY0LDE2ICs5NzMsMzAgQEAg
c3RhdGljIGJvb2wgdmdpY19pdHNfY2hlY2tfaWQoc3RydWN0IHZnaWNfaXRzICppdHMsIHU2NCBi
YXNlciwgdTMyIGlkLAo+ICAJLyogRmluZCB0aGUgYWRkcmVzcyBvZiB0aGUgYWN0dWFsIGVudHJ5
ICovCj4gIAlpbmRleCA9IGlkICUgKFNaXzY0SyAvIGVzeik7Cj4gIAlpbmRpcmVjdF9wdHIgKz0g
aW5kZXggKiBlc3o7Cj4gLQlnZm4gPSBpbmRpcmVjdF9wdHIgPj4gUEFHRV9TSElGVDsKPiAgCj4g
IAlpZiAoZWFkZHIpCj4gIAkJKmVhZGRyID0gaW5kaXJlY3RfcHRyOwo+ICAKPiAtb3V0Ogo+IC0J
aWR4ID0gc3JjdV9yZWFkX2xvY2soJml0cy0+ZGV2LT5rdm0tPnNyY3UpOwo+IC0JcmV0ID0ga3Zt
X2lzX3Zpc2libGVfZ2ZuKGl0cy0+ZGV2LT5rdm0sIGdmbik7Cj4gLQlzcmN1X3JlYWRfdW5sb2Nr
KCZpdHMtPmRldi0+a3ZtLT5zcmN1LCBpZHgpOwo+IC0JcmV0dXJuIHJldDsKPiArCXJldHVybiBf
X2lzX3Zpc2libGVfZ2ZuX2xvY2tlZChpdHMsIGluZGlyZWN0X3B0cik7Cj4gK30KPiArCj4gKy8q
Cj4gKyAqIENoZWNrIHdoZXRoZXIgYW4gZXZlbnQgSUQgY2FuIGJlIHN0b3JlZCBpbiB0aGUgY29y
cmVzcG9uZGluZyBJbnRlcnJ1cHQKPiArICogVHJhbnNsYXRpb24gVGFibGUsIHdoaWNoIHN0YXJ0
cyBhdCBkZXZpY2UtPml0dF9hZGRyLgo+ICsgKi8KPiArc3RhdGljIGJvb2wgdmdpY19pdHNfY2hl
Y2tfZXZlbnRfaWQoc3RydWN0IHZnaWNfaXRzICppdHMsIHN0cnVjdCBpdHNfZGV2aWNlICpkZXZp
Y2UsCj4gKwkJdTMyIGV2ZW50X2lkKQo+ICt7Cj4gKwljb25zdCBzdHJ1Y3QgdmdpY19pdHNfYWJp
ICphYmkgPSB2Z2ljX2l0c19nZXRfYWJpKGl0cyk7Cj4gKwlpbnQgaXRlX2VzeiA9IGFiaS0+aXRl
X2VzejsKPiArCWdwYV90IGdwYTsKPiArCj4gKwkvKiBtYXggdGFibGUgc2l6ZSBpczogQklUX1VM
TChkZXZpY2UtPm51bV9ldmVudGlkX2JpdHMpICogaXRlX2VzeiAqLwo+ICsJaWYgKGV2ZW50X2lk
ID49IEJJVF9VTEwoZGV2aWNlLT5udW1fZXZlbnRpZF9iaXRzKSkKPiArCQlyZXR1cm4gZmFsc2U7
Cj4gKwo+ICsJZ3BhID0gZGV2aWNlLT5pdHRfYWRkciArIGV2ZW50X2lkICogaXRlX2VzejsKPiAr
CXJldHVybiBfX2lzX3Zpc2libGVfZ2ZuX2xvY2tlZChpdHMsIGdwYSk7Cj4gIH0KPiAgCj4gIHN0
YXRpYyBpbnQgdmdpY19pdHNfYWxsb2NfY29sbGVjdGlvbihzdHJ1Y3QgdmdpY19pdHMgKml0cywK
PiBAQCAtMTA2MSw5ICsxMDg0LDYgQEAgc3RhdGljIGludCB2Z2ljX2l0c19jbWRfaGFuZGxlX21h
cGkoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QgdmdpY19pdHMgKml0cywKPiAgCWlmICghZGV2aWNl
KQo+ICAJCXJldHVybiBFX0lUU19NQVBUSV9VTk1BUFBFRF9ERVZJQ0U7Cj4gIAo+IC0JaWYgKGV2
ZW50X2lkID49IEJJVF9VTEwoZGV2aWNlLT5udW1fZXZlbnRpZF9iaXRzKSkKPiAtCQlyZXR1cm4g
RV9JVFNfTUFQVElfSURfT09SOwpJIHdvdWxkIHB1dArCoMKgwqAgaWYgKCF2Z2ljX2l0c19jaGVj
a19ldmVudF9pZChpdHMsIGRldmljZSwgZXZlbnRfaWQpKQrCoMKgIMKgwqDCoMKgIHJldHVybiBF
X0lUU19NQVBUSV9JRF9PT1I7CmhlcmUgaW5zdGVhZCBvZiBhZnRlciBzaW5jZSBpZiB0aGUgZXZl
bmRfaWQgbm90IGNvcnJlY3QsIG5vIHVzZSB0byBsb29rCnRoZSBpdGUgZm9yIGluc3RhbmNlLgo+
IC0KPiAgCWlmIChpdHNfY21kX2dldF9jb21tYW5kKGl0c19jbWQpID09IEdJVFNfQ01EX01BUFRJ
KQo+ICAJCWxwaV9uciA9IGl0c19jbWRfZ2V0X3BoeXNpY2FsX2lkKGl0c19jbWQpOwo+ICAJZWxz
ZQo+IEBAIC0xMDc2LDYgKzEwOTYsOSBAQCBzdGF0aWMgaW50IHZnaWNfaXRzX2NtZF9oYW5kbGVf
bWFwaShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCB2Z2ljX2l0cyAqaXRzLAo+ICAJaWYgKGZpbmRf
aXRlKGl0cywgZGV2aWNlX2lkLCBldmVudF9pZCkpCj4gIAkJcmV0dXJuIDA7Cj4gIAo+ICsJaWYg
KCF2Z2ljX2l0c19jaGVja19ldmVudF9pZChpdHMsIGRldmljZSwgZXZlbnRfaWQpKQo+ICsJCXJl
dHVybiBFX0lUU19NQVBUSV9JRF9PT1I7Cj4gKwo+ICAJY29sbGVjdGlvbiA9IGZpbmRfY29sbGVj
dGlvbihpdHMsIGNvbGxfaWQpOwo+ICAJaWYgKCFjb2xsZWN0aW9uKSB7Cj4gIAkJaW50IHJldCA9
IHZnaWNfaXRzX2FsbG9jX2NvbGxlY3Rpb24oaXRzLCAmY29sbGVjdGlvbiwgY29sbF9pZCk7CkJl
c2lkZXMgbG9vayBnb29kIHRvIG1lClJldmlld2VkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2Vy
QHJlZGhhdC5jb20+CgpFcmljCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
