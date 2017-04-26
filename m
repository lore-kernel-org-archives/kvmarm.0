From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 11/22] KVM: arm64: vgic-its: Interpret MAPD Size field
 and check related errors
Date: Wed, 26 Apr 2017 16:58:29 +0530
Message-ID: <CACJhumcEseZp44TaxsycAyVRZ-zFJPFETCXCZdNRNO=1WjTzqQ@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com> <1492164934-988-12-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-12-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 3:45 PM, Eric Auger <eric.auger@redhat.com> wrote:
> Up to now the MAPD's ITT size field has been ignored. It encodes
> the number of eventid bit minus 1. It should be used to check
> the eventid when a MAPTI command is issued on a device. Let's
> store the number of eventid bits in the its_device and do the
> check on MAPTI. Also make sure the ITT size field does
> not exceed the GITS_TYPER IDBITS field.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
