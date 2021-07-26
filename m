Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D34DC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:46:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C307B60F0F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:46:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C307B60F0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D2654A1A7;
	Mon, 26 Jul 2021 09:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@suse.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oK3IJMl1oagn; Mon, 26 Jul 2021 09:46:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2636E4A319;
	Mon, 26 Jul 2021 09:46:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4719E4A319
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:46:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0gaq0N1dnx2D for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 09:46:53 -0400 (EDT)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED6B2400D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:46:52 -0400 (EDT)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A7C301FE9B;
 Mon, 26 Jul 2021 13:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
 t=1627307211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ZiAHuSUF5GpewdhDR651VE/frt5eBLn372VpJAuXefM=;
 b=ilsO+j7an1sqs6PCY4+O2ekOYahK5KMfNQIwlEHl3QWUk0b8rkqmnTP/BH+lojr6QFNJr+
 eQmjtLeLriO3o37TxTBMPd+J+ukImvhY61V1QGY6pqEBU7zmN8DUPrOBc8Q256KcpYfX2v
 VQUV3Crm8MaVolzT2AOHVInwz0VB2kQ=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 11F7C13A96;
 Mon, 26 Jul 2021 13:46:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id JCAGA8u8/mD+BAAAGKfGzw
 (envelope-from <jgross@suse.com>); Mon, 26 Jul 2021 13:46:51 +0000
Subject: Re: [PATCH 5/6] kvm: allocate vcpu pointer array separately
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-6-jgross@suse.com>
 <001b7eab-ed7b-da27-a623-057781cf1211@redhat.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <2aed0475-3df0-5ac6-f393-042b5e798ebc@suse.com>
Date: Mon, 26 Jul 2021 15:46:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <001b7eab-ed7b-da27-a623-057781cf1211@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Sean Christopherson <seanjc@google.com>,
 kvmarm@lists.cs.columbia.edu, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Borislav Petkov <bp@alien8.de>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Jim Mattson <jmattson@google.com>
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
Content-Type: multipart/mixed; boundary="===============6802069176331568966=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============6802069176331568966==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NdvuequyBuLErJpZlLkjFUBjoMShZRDzR"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NdvuequyBuLErJpZlLkjFUBjoMShZRDzR
Content-Type: multipart/mixed; boundary="Ok8zyytoRSPYkRItR0LPUTSMA13wQinlR";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 kvmarm@lists.cs.columbia.edu
Message-ID: <2aed0475-3df0-5ac6-f393-042b5e798ebc@suse.com>
Subject: Re: [PATCH 5/6] kvm: allocate vcpu pointer array separately
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-6-jgross@suse.com>
 <001b7eab-ed7b-da27-a623-057781cf1211@redhat.com>
In-Reply-To: <001b7eab-ed7b-da27-a623-057781cf1211@redhat.com>

--Ok8zyytoRSPYkRItR0LPUTSMA13wQinlR
Content-Type: multipart/mixed;
 boundary="------------84BEFF3C3D043EFE533E07CE"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------84BEFF3C3D043EFE533E07CE
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 26.07.21 15:40, Paolo Bonzini wrote:
> On 01/07/21 17:41, Juergen Gross wrote:
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 if (!has_vhe())
>> +=C2=A0=C2=A0=C2=A0 if (!has_vhe()) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(kvm->vcpus);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(kvm);
>> -=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vfree(kvm->vcpus);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vfree(kvm);
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 }
>> =C2=A0 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>> diff --git a/arch/x86/include/asm/kvm_host.h=20
>> b/arch/x86/include/asm/kvm_host.h
>> index 79138c91f83d..39cbc4b6bffb 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1440,10 +1440,7 @@ static inline void=20
>> kvm_ops_static_call_update(void)
>> =C2=A0 }
>> =C2=A0 #define __KVM_HAVE_ARCH_VM_ALLOC
>> -static inline struct kvm *kvm_arch_alloc_vm(void)
>> -{
>> -=C2=A0=C2=A0=C2=A0 return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_A=
CCOUNT |=20
>> __GFP_ZERO);
>> -}
>> +struct kvm *kvm_arch_alloc_vm(void);
>> =C2=A0 void kvm_arch_free_vm(struct kvm *kvm);
>> =C2=A0 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3af398ef1fc9..a9b0bb2221ea 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10741,9 +10741,28 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu,=
=20
>> int cpu)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 static_call(kvm_x86_sched_in)(vcpu, cpu=
);
>> =C2=A0 }
>> +struct kvm *kvm_arch_alloc_vm(void)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct kvm *kvm;
>> +
>> +=C2=A0=C2=A0=C2=A0 kvm =3D __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_=
ACCOUNT |=20
>> __GFP_ZERO);
>> +=C2=A0=C2=A0=C2=A0 if (!kvm)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>> +
>> +=C2=A0=C2=A0=C2=A0 kvm->vcpus =3D __vmalloc(KVM_MAX_VCPUS * sizeof(vo=
id *),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_KERNEL_ACCOUNT | __GFP_ZERO);=

>> +=C2=A0=C2=A0=C2=A0 if (!kvm->vcpus) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vfree(kvm);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm =3D NULL;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>=20
> Let's keep this cleaner:
>=20
> 1) use kvfree in the common version of kvm_arch_free_vm
>=20
> 2) split __KVM_HAVE_ARCH_VM_ALLOC and __KVM_HAVE_ARCH_VM_FREE (ARM does=
=20
> not need it once kvfree is used)
>=20
> 3) define a __kvm_arch_free_vm version that is defined even if=20
> !__KVM_HAVE_ARCH_VM_FREE, and which can be used on x86.

Okay, will do so.


Juergen

--------------84BEFF3C3D043EFE533E07CE
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------84BEFF3C3D043EFE533E07CE--

--Ok8zyytoRSPYkRItR0LPUTSMA13wQinlR--

--NdvuequyBuLErJpZlLkjFUBjoMShZRDzR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmD+vMoFAwAAAAAACgkQsN6d1ii/Ey/D
qwf8Cl9sgiU23MWu9UaBALuML1IVuGXCRHWemYDoKUAiWxF/6fFW0hwl8LbfGbhOhg9pZCBDYoc4
oNHrCnUV8DcCddFhZ2wNEC5iyAOu2ZTLLiVhUDi3VV7YXBPOUGzMxce1EpKEBI8/IuGEe1t4sPMc
RhD2toppp90E0/Bjz/PoldrxNOFvxdu5/nScdR+ufcqLSdti2QBTUOwgo7B6y0qWTHHA01pt9QJu
oMkgmA5KZFtii+5YOrR9ZZ+4ll8IWwXwzPtpi6bPN1Sst2fBQJGuaa5bZAFYUtjSQqGQgWOFefvp
7YcdWT7tqY7XGYQVrwj08aabv05rQVLjwHrl8LW/9g==
=feS0
-----END PGP SIGNATURE-----

--NdvuequyBuLErJpZlLkjFUBjoMShZRDzR--

--===============6802069176331568966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6802069176331568966==--
