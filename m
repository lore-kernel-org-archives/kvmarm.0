Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17B3C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 10:51:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B5D649EFF;
	Wed, 16 Mar 2022 06:51:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JACA5RfXicVZ; Wed, 16 Mar 2022 06:51:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02A8640BF0;
	Wed, 16 Mar 2022 06:51:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D569A4089C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 06:51:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hp8DFALbXxFO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 06:51:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 442FB4052C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 06:51:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647427876;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=vu3aeh48Tug76fxpmH2PAoqqXJjQdjheEKaJPV3hhHw=;
 b=Sl9geH2I7Dd1/GZ8CkydWeia/UpE7SBqc3Z41hsHfHonVFXF1W54KxZZ0i97X9vZUQWAgy
 G89cew2Z1k0nBK1owIp7F4fzuEsn3eRDP5v4U2eNeVjLcTY2utcIW3ti2rGEN96jGbasnq
 MEILabIUt26Njw6dv3Wb0pecUm/yNc0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-kjPiBjwuM-aZEghXvjUGhg-1; Wed, 16 Mar 2022 06:51:13 -0400
X-MC-Unique: kjPiBjwuM-aZEghXvjUGhg-1
Received: by mail-wm1-f72.google.com with SMTP id
 o19-20020a05600c379300b0038c7117460dso348307wmr.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 03:51:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vu3aeh48Tug76fxpmH2PAoqqXJjQdjheEKaJPV3hhHw=;
 b=5ZEHymbFFYlLhIThe6xCKwQTvwfUhCWcb8JFqfDDB+Q/I/GMcTQJu9d51sDnpBgsxa
 zXXkFSC6Sso7en7fJWnme9dRMYEJCk49wnLI2eIJxvXx6bYVMg0seUJ1qnHWmxMNGGYp
 oIEm3worriZtLoeAKxT5jb2C3OMLqELi0p3IHiXrG/hR62H+94nbdMS3XHXshBYKIlnz
 900Dvzo2TodIzKnDZY5lPQMBQpyLFFFLB6bh8DB77v6MJZ0zKhek1yNfK/lzB9ESMKf5
 994M30UI0mZJQkUBArO53M4BTZtqdqhXWsWYkiPkQKb/8/AciXr7Z53ZFEYHT43w4Cr2
 K1bw==
X-Gm-Message-State: AOAM532hZpPRjtbk8Y/Bz6pLSV96rv6bTJ/yIi5m3QTlOrMkvlho7MqV
 IPQsdMYFmjAcXO7gKstbnei3LXjmoR9xuVbI0d/l5bKRGToerUEBmkFhn7Cj4vkFJDMyE+N6Ndr
 1oN44zZtbvoe1SPbwYvGpsRb8
X-Received: by 2002:a1c:2744:0:b0:382:a9b7:1c8a with SMTP id
 n65-20020a1c2744000000b00382a9b71c8amr6808713wmn.187.1647427872494; 
 Wed, 16 Mar 2022 03:51:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTLdZCDbB2DZC73GQbo1HkG4OcuIYdVyG+RtfKXW12VXxbS+y0PyvboT8fLPkRQZmWzTJFjQ==
X-Received: by 2002:a1c:2744:0:b0:382:a9b7:1c8a with SMTP id
 n65-20020a1c2744000000b00382a9b71c8amr6808701wmn.187.1647427872276; 
 Wed, 16 Mar 2022 03:51:12 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 m185-20020a1c26c2000000b003899ed333ffsm4443134wmm.47.2022.03.16.03.51.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 03:51:11 -0700 (PDT)
Date: Wed, 16 Mar 2022 11:51:09 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Message-ID: <20220316105109.oi5g532ylijzldte@gator>
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
 <20220315152528.u7zdkjlq6okahidm@gator>
 <YjG/FyAaFsAxTLKd@monolith.localdoman>
MIME-Version: 1.0
In-Reply-To: <YjG/FyAaFsAxTLKd@monolith.localdoman>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Mar 16, 2022 at 10:42:31AM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Mar 15, 2022 at 04:25:28PM +0100, Andrew Jones wrote:
> > On Tue, Mar 15, 2022 at 01:33:57PM +0000, Alexandru Elisei wrote:
> > > Hi,
> > > 
> > > Arm is planning to upstream tests that are being developed as part of the
> > > Confidential Compute Architecture [1]. Some of the tests target the
> > > attestation part of creating and managing a confidential compute VM, which
> > > requires the manipulation of messages in the Concise Binary Object
> > > Representation (CBOR) format [2].
> > > 
> > > I would like to ask if it would be acceptable from a license perspective to
> > > include the QCBOR library [3] into kvm-unit-tests, which will be used for
> > > encoding and decoding of CBOR messages.
> > > 
> > > The library is licensed under the 3-Clause BSD license, which is compatible
> > > with GPLv2 [4]. Some of the files that were created inside Qualcomm before
> > > the library was open-sourced have a slightly modified 3-Clause BSD license,
> > > where a NON-INFRINGMENT clause is added to the disclaimer:
> > > 
> > > "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
> > > WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> > > MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
> > > ARE DISCLAIMED" (emphasis by me on the added clause).
> > > 
> > > The files in question include the core files that implement the
> > > encode/decode functionality, and thus would have to be included in
> > > kvm-unit-tests. I believe that the above modification does not affect the
> > > compatibility with GPLv2.
> > > 
> > > I would also like to mention that the QCBOR library is also used in Trusted
> > > Firmware-M [5], which is licensed under BSD 3-Clause.
> > > 
> > > [1] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> > > [2] https://datatracker.ietf.org/doc/html/rfc8949
> > > [3] https://github.com/laurencelundblade/QCBOR
> > > [4] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
> > > [5] https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git/tree/lib/ext/qcbor
> > > 
> > > Thanks,
> > > Alex
> > >
> > 
> > Assuming the license is OK (I'm not educated in that stuff enough to give
> > an opinion), then the next question is how do we want to integrate it?
> > Bring it all in, like we did libfdt? Or use a git submodule?
> 
> This is still a work in progress and at this time I'm not sure how it will
> end up looking. Do you have a preference for one or the other?
>

I think I prefer a submodule, but I'm all ears on this. By coincidence the
same topic is now also being discussed here

https://lore.kernel.org/kvm/334cc93e-9843-daa9-5846-394c199e294f@redhat.com/T/#mb5db3e9143e4f2ca47d24a32b30e7b2f014934e8

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
